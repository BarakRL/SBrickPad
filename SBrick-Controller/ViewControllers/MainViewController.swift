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

class MainViewController: UITableViewController, SBrickManagerDelegate, SBrickDelegate {

    var manager: SBrickManager!
    var sbrick: SBrick?
    
    let driveChannel: UInt8 = 2
    let steerChannel: UInt8 = 0
    let steerCW: Bool = false
    
    var buttonPressActions =    [GameControllerButton: GameControllerPressAction]()
    var buttonReleaseActions =  [GameControllerButton: GameControllerPressAction]()
    var buttonValueActions =    [GameControllerButton: GameControllerValueAction]()
    
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
    
    var player: AVAudioPlayer?
    func playSound(name soundName: String, withExtension ext: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        player?.stop()
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
        
        let pressAction = self.buttonPressActions[button]
        let releaseAction = self.buttonReleaseActions[button]
        let valueAction = self.buttonValueActions[button]
        
        let none = "-"
        
        cell.detailTextLabel?.text = "\(pressAction?.name ?? none) / \(releaseAction?.name ?? none) / \(valueAction?.name ?? none)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        let button = GameControllerButton.allButtons[indexPath.row]
        
        let vc = ButtonActionsViewController.instantiate()
        vc.pressAction = self.buttonPressActions[button]
        vc.releaseAction = self.buttonReleaseActions[button]
        vc.valueAction = self.buttonValueActions[button]
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
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
        
        let actionDict = pressed ? self.buttonPressActions : self.buttonReleaseActions
        guard let action = actionDict[button] else { return }
        
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
        
        
        switch action {
            
        case .playSound(let soundName, let ext):
            self.playSound(name: soundName, withExtension: ext)
        
        case .stopSound(_,_):
            self.stopSound()
            
        case .drive(let channel, let cw, let power):
            guard let sbrick = self.sbrick else { return }
            sbrick.channels[Int(channel)].drive(power: power, isCW: cw)
            
            
        case .stop(let channel):
            guard let sbrick = self.sbrick else { return }
            sbrick.channels[Int(channel)].stop()
            
        }
        
    }
    
    func onButton(_ button: GameControllerButton, value: Float) {
        
        guard let action = buttonValueActions[button] else { return }
        
        //print("\(button) value: \(value)")
        
        if let index = GameControllerButton.allButtons.index(of: button) {
            let indexPath = IndexPath(row: index, section: 0)
            scrollToIfNeeded(indexPath, andSelect: false)
            
            if let cell = self.tableView.cellForRow(at: indexPath) as? ButtonCell {
                cell.progressView.progress = abs(value)
            }
        }
        
        switch action {
            
        case let .drive(channel, cw, minPower, maxPower, easing):
            guard let sbrick = self.sbrick else { return }
            
            let power = GameControllerValueAction.power(fromValue: value, minPower: minPower, maxPower: maxPower, easing: easing)
            
            if power.value == 0 {
                sbrick.channels[Int(channel)].stop()
            }
            else {
                let isCW = power.isNegative ? !cw : cw
                sbrick.channels[Int(channel)].drive(power: power.value, isCW: isCW)
            }
            
        }
        
    }

    
    
    
    func loadActions() {
        
        buttonPressActions.removeAll()
        buttonReleaseActions.removeAll()
        
        buttonValueActions[.leftThumbstickX] = GameControllerValueAction.drive(channel: steerChannel, cw: steerCW, minPower: 0, maxPower: 0xFF, easing: .easeIn)
        
        buttonValueActions[.rightThumbstickY] = GameControllerValueAction.drive(channel: driveChannel, cw: false, minPower: 0, maxPower: 0xFF, easing: .easeIn)
        
        buttonPressActions[.left]   = GameControllerPressAction.drive(channel: steerChannel, cw: !steerCW, power: 0xFF)
        buttonReleaseActions[.left] = GameControllerPressAction.stop(channel: steerChannel)
        
        buttonPressActions[.right]   = GameControllerPressAction.drive(channel: steerChannel, cw: steerCW, power: 0xFF)
        buttonReleaseActions[.right] = GameControllerPressAction.stop(channel: steerChannel)
        
        buttonValueActions[.buttonA] = GameControllerValueAction.drive(channel: driveChannel, cw: false, minPower: 0, maxPower: 0xFF, easing: .linear)
        buttonValueActions[.buttonB] = GameControllerValueAction.drive(channel: driveChannel, cw: true, minPower: 0, maxPower: 0xFF, easing: .linear)

        buttonPressActions[.leftShoulder] = GameControllerPressAction.playSound(soundName: "horn", ext: "wav")
        buttonReleaseActions[.leftShoulder] = GameControllerPressAction.stopSound(soundName: "horn", ext: "wav")
        
        buttonPressActions[.rightShoulder] = GameControllerPressAction.playSound(soundName: "engine", ext: "mp3")
        buttonReleaseActions[.rightShoulder] = GameControllerPressAction.stopSound(soundName: "engine", ext: "mp3")

    }
    
}


