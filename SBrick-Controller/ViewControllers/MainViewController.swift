//
//  ViewController.swift
//  SBrick-iCade
//
//  Created by Barak Harel on 4/16/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit
import SBrick
import CoreBluetooth
import AVFoundation
import GameController
import JSONCodable

class MainViewController: UITableViewController, SBrickManagerDelegate, SBrickDelegate {

    var manager: SBrickManager!
    var sbrick: SBrick?
    
    let driveChannel: UInt8 = 2
    let steerChannel: UInt8 = 0
    let steerCW: Bool = false
    
    var buttonActions = [GameControllerButtonAction]()
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SBrick iCade"
        
        tableView.allowsMultipleSelection = true
        
        manager = SBrickManager(delegate: self)
        
        statusLabel.text = "Discovering..."
        manager.startDiscovery()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameControllerConnected(notification:)), name: .GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameControllerDisconnected(notification:)), name: .GCControllerDidDisconnect, object: nil)
        
        if let gameController = GCController.controllers().first {
            self.gameController = gameController
        }
        
        loadActions()
    }
    
    
    
    var gameController: GCController? {
        didSet {
            
            guard let gameController = gameController else { return }
            
            gameController.controllerPausedHandler = { [unowned self] controller in
                self.onButton(.start, pressed: true)
                self.onButton(.start, pressed: false)
            }
            
            linkButton(gameController.gamepad?.buttonA, to: .buttonA)
            linkButton(gameController.gamepad?.buttonB, to: .buttonB)
            linkButton(gameController.gamepad?.buttonX, to: .buttonX)
            linkButton(gameController.gamepad?.buttonY, to: .buttonY)
            linkButton(gameController.gamepad?.leftShoulder, to: .leftShoulder)
            linkButton(gameController.gamepad?.rightShoulder, to: .rightShoulder)
            linkButton(gameController.gamepad?.dpad.up, to: .up)
            linkButton(gameController.gamepad?.dpad.down, to: .down)
            linkButton(gameController.gamepad?.dpad.left, to: .left)
            linkButton(gameController.gamepad?.dpad.right, to: .right)
            linkButton(gameController.extendedGamepad?.leftTrigger, to: .leftTrigger)
            linkButton(gameController.extendedGamepad?.rightTrigger, to: .rightTrigger)
            
            linkAxis(gameController.extendedGamepad?.leftThumbstick.xAxis, to: .leftThumbstickX)
            linkAxis(gameController.extendedGamepad?.leftThumbstick.yAxis, to: .leftThumbstickY)
            linkAxis(gameController.extendedGamepad?.rightThumbstick.xAxis, to: .rightThumbstickX)
            linkAxis(gameController.extendedGamepad?.rightThumbstick.yAxis, to: .rightThumbstickY)
            
        }
    }
    
    func linkAxis(_ axis: GCControllerAxisInput?, to button: GameControllerButton) {
        
        guard let axis = axis else { return }
        
        axis.valueChangedHandler = { [unowned self] axis, value in
            self.onButton(button, value: value)
        }
    }
    
    func linkButton(_ input: GCControllerButtonInput?,to button: GameControllerButton) {
        
        guard let input = input else { return }
        
        input.valueChangedHandler = { [unowned self]  input, value, pressed in
            self.onButton(button, value: value)
        }
        
        input.pressedChangedHandler = { [unowned self]  input, value, pressed in
            self.onButton(button, pressed: pressed)
        }
        
    }
    
    
    func gameControllerConnected(notification: NSNotification) {
     
        guard let gameController = notification.object as? GCController else { return }
        self.gameController = gameController
        
        print("connected: \(gameController)")
    }
    
    func gameControllerDisconnected(notification: NSNotification) {
        
        guard let gameController = notification.object as? GCController else { return }
        if self.gameController == gameController {
            self.gameController = nil
        }
        
        print("disconnected: \(gameController)")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func sbrickManager(_ sbrickManager: SBrickManager, didDiscover sbrick: SBrick) {
        
        //stop for now
        sbrickManager.stopDiscovery()
        
        statusLabel.text = "Found: \(sbrick.manufacturerData.deviceIdentifier)"
        
        //connect
        sbrick.delegate = self
        sbrickManager.connect(to: sbrick)
    }
    
    func sbrickManager(_ sbrickManager: SBrickManager, didUpdateBluetoothState bluetoothState: CBManagerState) {
        
    }
    
    func sbrickConnected(_ sbrick: SBrick) {
        statusLabel.text = "SBrick connected!"
        self.sbrick = sbrick
        sbrick.channels[Int(driveChannel)].drivePowerThreshold = 32
    }
    
    func sbrickDisconnected(_ sbrick: SBrick) {
        statusLabel.text = "SBrick disconnected :("        
        self.sbrick = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusLabel.text = "Reconnecting: \(sbrick.manufacturerData.deviceIdentifier)"
            self.manager.connect(to: sbrick)
        }
    }
    
    func sbrickReady(_ sbrick: SBrick) {
        
        statusLabel.text = "SBrick ready!"
    }
    
    func sbrick(_ sbrick: SBrick, didRead data: Data?) {
        
        guard let data = data else { return }
        print("sbrick [\(sbrick.name)] did read: \([UInt8](data))")
    }
    
    var accPower: UInt8 = 0
    var accTimer: Timer?
    
    var soundPlayers = [URL:AVAudioPlayer]()
    
    func playSound(name soundName: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("url not found")
            return
        }
        
        //stop
        stopSound(name: soundName, withExtension: ext)
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()
            
            soundPlayers[url] = player
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopSound(name soundName: String, withExtension ext: String) {
        
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("url not found")
            return
        }
        
        //release
        if let player = soundPlayers[url] {
            player.stop()
        }
    }
    
    var lastScrolledToIndexPath: IndexPath?
    func scrollToIfNeeded(_ indexPath: IndexPath, andSelect shouldSelect: Bool) {
        
        guard lastScrolledToIndexPath != indexPath else { return }
        
        lastScrolledToIndexPath = indexPath
        if shouldSelect {
            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
        else {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
}

extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameControllerButton.allButtons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let button = GameControllerButton.allButtons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = button.name
        
        let pressedActions      = self.buttonActions(for: button, event: .pressed)
        let releasedActions     = self.buttonActions(for: button, event: .released)
        let valueChangedActions = self.buttonActions(for: button, event: .valueChanged)
        
        let pressedActionTitle      = pressedActions.count > 1      ? "Multiple" : pressedActions.first?.action.name       ?? "-"
        let releasedActionTitle     = releasedActions.count > 1     ? "Multiple" : releasedActions.first?.action.name      ?? "-"
        let valueChangedActionTitle = valueChangedActions.count > 1 ? "Multiple" : valueChangedActions.first?.action.name  ?? "-"
        
        cell.detailTextLabel?.text = "\(pressedActionTitle) / \(releasedActionTitle) / \(valueChangedActionTitle)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        let button = GameControllerButton.allButtons[indexPath.row]
        
        let vc = ButtonActionsViewController.instantiate()
        vc.button = button
        vc.pressedActions       = self.buttonActions(for: button, event: .pressed)
        vc.releasedActions      = self.buttonActions(for: button, event: .released)
        vc.valueChangedActions  = self.buttonActions(for: button, event: .valueChanged)
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
}

extension MainViewController: ButtonActionsViewControllerDelegate {
    
    func buttonActionsViewController(_ buttonActionsViewController: ButtonActionsViewController, shouldSaveActionsFor button: GameControllerButton) {
        
        removeButtonActions(for: button)
        buttonActions.append(contentsOf: buttonActionsViewController.pressedActions)
        buttonActions.append(contentsOf: buttonActionsViewController.releasedActions)
        buttonActions.append(contentsOf: buttonActionsViewController.valueChangedActions)
        
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

extension MainViewController {
    
    open override var keyCommands: [UIKeyCommand]? {
        
        var keyCommands = [UIKeyCommand]()
        keyCommands.append(contentsOf: ICade.pressCommands(action: #selector(keyPressed(sender:))))
        keyCommands.append(contentsOf: ICade.releaseCommands(action: #selector(keyReleased(sender:))))
        
        return keyCommands
    }
    
    func keyReleased(sender: UIKeyCommand) {
        
        self.becomeFirstResponder()
        guard let button = ICadeButton.button(forReleaseKey: sender.input) else { print("Unknown key: \(sender.input)"); return }
        onButton(button, pressed: false)
    }
    
    func keyPressed(sender: UIKeyCommand) {
        
        self.becomeFirstResponder()
        guard let button = ICadeButton.button(forPressKey: sender.input) else { print("Unknown key: \(sender.input)"); return }
        onButton(button, pressed: true)
    }
    
    func onButton(_ button: GameControllerButton, pressed: Bool) {
        
        let event: GameControllerButton.Event = pressed ? .pressed : .released
        let buttonActions = self.buttonActions(for: button, event: event)
        
        //print("\(button) \(pressed ? "pressed" : "released")")
        
        if let index = GameControllerButton.allButtons.index(of: button) {
            
            let indexPath = IndexPath(row: index, section: 0)
            if pressed {
                self.scrollToIfNeeded(indexPath, andSelect: true)
            }
            else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        for buttonAction in buttonActions {
        
            let action = buttonAction.action
            
            if let action = action as? PlaySoundAction {
                
                self.playSound(name: action.soundName, withExtension: action.ext)
            }
            else if let action = action as? StopSoundAction {
                
                self.stopSound(name: action.soundName, withExtension: action.ext)
            }
            else if let action = action as? DriveAction {
                
                guard let sbrick = self.sbrick else { continue }
                sbrick.channels[Int(action.channel)].drive(power: action.power, isCW: action.isCW)
            }
            else if let action = action as? StopAction {
                
                guard let sbrick = self.sbrick else { continue }
                sbrick.channels[Int(action.channel)].stop()
            }
        }
        
    }
    
    func onButton(_ button: GameControllerButton, value: Float) {
        
        let buttonActions = self.buttonActions(for: button, event: .valueChanged)
        
        //print("\(button) value: \(value)")
        
        if let index = GameControllerButton.allButtons.index(of: button) {
            let indexPath = IndexPath(row: index, section: 0)
            scrollToIfNeeded(indexPath, andSelect: false)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? ButtonCell {
                cell.progressView.progress = abs(value)
            }
        }
        
        for buttonAction in buttonActions {
            
            let action = buttonAction.action
            
            if let action = action as? DriveValueAction {
                
                guard let sbrick = self.sbrick else { continue }
                
                let power = action.relativePower(fromValue: value)
                
                if power.value == 0 {
                    sbrick.channels[Int(action.channel)].stop()
                }
                else {
                    let isCW = power.isNegative ? !action.isCW : action.isCW
                    sbrick.channels[Int(action.channel)].drive(power: power.value, isCW: isCW)
                }
            }
        }
    }

    
    
    
    func loadActions() {
        
        //buttonPressActions.removeAll()
        //buttonReleaseActions.removeAll()
        buttonActions.removeAll()
        
        buttonActions.append(GameControllerButtonAction(button: .leftThumbstickX,
                                                        action: DriveValueAction(channel: steerChannel, minPower: 0, maxPower: 0xFF, isCW: steerCW, easing: .easeIn),
                                                        forEvent: .valueChanged))
        
        buttonActions.append(GameControllerButtonAction(button: .rightThumbstickY,
                                                        action: DriveValueAction(channel: driveChannel, minPower: 0, maxPower: 0xFF, isCW: false, easing: .easeIn),
                                                        forEvent: .valueChanged))
        
        buttonActions.append(GameControllerButtonAction(button: .left,
                                                        action: DriveAction(channel: steerChannel, power: 0xFF, isCW: !steerCW),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .left,
                                                        action: StopAction(channel: steerChannel),
                                                        forEvent: .released))
        
        buttonActions.append(GameControllerButtonAction(button: .right,
                                                        action: DriveAction(channel: steerChannel, power: 0xFF, isCW: steerCW),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .right,
                                                        action: StopAction(channel: steerChannel),
                                                        forEvent: .released))
        
        buttonActions.append(GameControllerButtonAction(button: .buttonA,
                                                        action: DriveAction(channel: driveChannel, power: 0xFF, isCW: false),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .buttonA,
                                                        action: StopAction(channel: driveChannel),
                                                        forEvent: .released))
        
        buttonActions.append(GameControllerButtonAction(button: .buttonA,
                                                        action: PlaySoundAction(soundName: "engine", ext: "mp3"),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .buttonA,
                                                        action: StopSoundAction(soundName: "engine", ext: "mp3"),
                                                        forEvent: .released))
        
        buttonActions.append(GameControllerButtonAction(button: .buttonB,
                                                        action: DriveValueAction(channel: driveChannel, minPower: 0, maxPower: 0xFF, isCW: true),
                                                        forEvent: .valueChanged))
        
        buttonActions.append(GameControllerButtonAction(button: .leftShoulder,
                                                        action: PlaySoundAction(soundName: "horn", ext: "wav"),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .leftShoulder,
                                                        action: StopSoundAction(soundName: "horn", ext: "wav"),
                                                        forEvent: .released))
        
        buttonActions.append(GameControllerButtonAction(button: .rightShoulder,
                                                        action: PlaySoundAction(soundName: "engine", ext: "mp3"),
                                                        forEvent: .pressed))
        
        buttonActions.append(GameControllerButtonAction(button: .rightShoulder,
                                                        action: StopSoundAction(soundName: "engine", ext: "mp3"),
                                                        forEvent: .released))
        
        //TEST loading/saving:
        
        if let json = try? buttonActions.toJSON(), let jsonArray = json as? [Any] {
            
            let buttonActions = try! [GameControllerButtonAction].init(JSONArray: jsonArray)
            print(buttonActions)
        }
    }
    
    func buttonActions(for button: GameControllerButton, event: GameControllerButton.Event) -> [GameControllerButtonAction] {
        
        var actions = [GameControllerButtonAction]()
        for buttonAction in buttonActions {
            if buttonAction.button == button && buttonAction.event == event {
                actions.append(buttonAction)
            }
        }
        
        return actions
    }
    
    func removeButtonActions(for button: GameControllerButton) {
        
        for i in (0..<buttonActions.count).reversed() {
            if buttonActions[i].button == button {
                buttonActions.remove(at: i)
            }
        }
    }
}


