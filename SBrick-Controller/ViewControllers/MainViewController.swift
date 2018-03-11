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
    
    var buttonActions = [GameControllerButtonAction]() {
        didSet {
            tableView.reloadData()
        }
    }
    var isModified:Bool = false {
        didSet {
            updateTitle()
        }
    }
    var actionsFilename: String? {
        didSet {
            UserDefaults.standard.set(actionsFilename, forKey: "actionsFilename")
            updateTitle()
        }
    }
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    let connectingColor: UIColor = UIColor(red: 1, green: 1, blue: 0.5, alpha: 1)
    let connectedColor: UIColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
    let disconnectedColor: UIColor = UIColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
    
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
    
    func updateTitle() {
        
        let title = self.actionsFilename ?? "Button Actions"
        self.title = "\(title)\(isModified ? "*" : "")"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        
        manager = SBrickManager(delegate: self)
        
        statusLabel.text = "Discovering..."
        statusView.backgroundColor = connectingColor
        manager.startDiscovery()
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameControllerConnected(notification:)), name: .GCControllerDidConnect, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameControllerDisconnected(notification:)), name: .GCControllerDidDisconnect, object: nil)
        
        if let gameController = GCController.controllers().first {
            self.gameController = gameController
        }
        
        installRecourcesIfNeeded()
        loadLastActionsFile()
        updateTitle()
    }
    
    func installRecourcesIfNeeded() {
        
        if FilePickerViewController.findFiles(withExtensions: ["mp3","wav"]).count == 0 {
            let sounds = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "Sounds")
            FilePickerViewController.install(filePaths: sounds)
        }
        
        if FilePickerViewController.findFiles(withExtensions: ["json"]).count == 0 {
            let actions = Bundle.main.paths(forResourcesOfType: nil, inDirectory: "Actions")
            FilePickerViewController.install(filePaths: actions)
        }
    }
    
    //MARK: - GCController
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
    
    @objc func gameControllerConnected(notification: NSNotification) {
        
        guard let gameController = notification.object as? GCController else { return }
        self.gameController = gameController
        
        print("connected: \(gameController)")
    }
    
    @objc func gameControllerDisconnected(notification: NSNotification) {
        
        guard let gameController = notification.object as? GCController else { return }
        if self.gameController == gameController {
            self.gameController = nil
        }
        
        print("disconnected: \(gameController)")
    }
    
    //MARK: - SBrick
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
        statusView.backgroundColor = connectedColor
        self.sbrick = sbrick
    }
    
    func sbrickDisconnected(_ sbrick: SBrick) {
        statusLabel.text = "SBrick disconnected :("
        statusView.backgroundColor = disconnectedColor
        self.sbrick = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusLabel.text = "Reconnecting: \(sbrick.manufacturerData.deviceIdentifier)"
            self.statusView.backgroundColor = self.connectingColor
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
    
    //MARK: - Actions
    var soundPlayers = [String:AVAudioPlayer]()
    func playSound(filename: String?, loop: Bool) {
        
        guard let filename = filename else { return }
        
        let url = FilePickerViewController.url(forFilename: filename)
        
        //stop
        stopSound(filename: filename)
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.play()
            
            soundPlayers[filename] = player
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopSound(filename: String?) {
        
        if let filename = filename { //stop single player
            
            if let player = soundPlayers[filename] {
                player.stop()
            }
            
        }
        else { //nil => stop all
            
            for (_, player) in soundPlayers {
                player.stop()
            }
        }
    }
    
    //MARK: - Scroll
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


//MARK: - Load / Save
extension MainViewController: FilePickerViewControllerDelegate {
    
    @IBAction func organizePressed() {
        
        let isModified = self.isModified
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Load actions", style: .default, handler: { [weak self] (action) -> Void in
            self?.loadActions(saveWarning: isModified)
        }))
        
        alert.addAction(UIAlertAction(title: "Save actions", style: .default, handler: { [weak self] (action) -> Void in
            self?.saveActions(onComplete: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Clear all", style: .destructive, handler: { [weak self] (action) -> Void in
            self?.clearActions(saveWarning: isModified)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveActions(onComplete: (()->())?) {
        
        var inputTextField: UITextField?
        let alert = UIAlertController(title: "Save as:", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) -> Void in
            self?.isModified = false
            if let filename = inputTextField?.text, filename.count > 0 {
                self?.checkAndSave(filename: filename, onComplete: onComplete)
            }
        }))
        alert.addTextField(configurationHandler: { [weak self] textField in
            textField.placeholder = "Name"
            textField.text = self?.actionsFilename
            textField.clearButtonMode = .always
            inputTextField = textField
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkAndSave(filename: String, onComplete: (()->())?) {
        
        var filename = filename
        if !filename.hasSuffix(".json") {
            filename = "\(filename).json"
        }
        
        if FilePickerViewController.fileExists(filename: filename) {
            
            let alert = UIAlertController(title: "File already exist", message: "overwrite existing file?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [weak self] (action) -> Void in
                self?.saveAction(filename: filename)
                onComplete?()
            }))
            
            present(alert, animated: true, completion: nil)
        }
        else {
            saveAction(filename: filename)
            onComplete?()
        }
    }
    
    func saveAction(filename: String) {
        
        var filename = filename
        if !filename.hasSuffix(".json") {
            filename = "\(filename).json"
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        if let jsonData = try? jsonEncoder.encode(buttonActions) {
            FilePickerViewController.save(jsonData, asFilename: filename)
        }
    }
    
    func clearActions(saveWarning: Bool) {
        
        if saveWarning {
            
            showSaveWarning(onComplete: { [weak self] in
                self?.clearActions()
            })
        }
        else {
            clearActions()
        }
    }
    
    func clearActions() {
        
        buttonActions = []
        isModified = false
        actionsFilename = nil
        
    }
    
    func loadActions(saveWarning: Bool) {
        
        if saveWarning {
            
            showSaveWarning(onComplete: { [weak self] in
                self?.loadActions()
            })
        }
        else {
            loadActions()
        }
    }
    
    func showSaveWarning(onComplete: @escaping ()->()) {
        
        let alert = UIAlertController(title: "Save actions first?", message: "unsaved changes will be lost", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { action in
            onComplete()
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
            self?.saveActions(onComplete: onComplete)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadActions() {
        
        let filePicker = FilePickerViewController.instantiate()
        filePicker.identifier = "loadActions"
        filePicker.title = "Load Actions"
        filePicker.fileExtensions = ["json"]
        filePicker.delegate = self
        
        let nav = UINavigationController(rootViewController: filePicker)
        present(nav, animated: true, completion: nil)
    }
    
    func loadActions(filename: String) {
                
        if let jsonData = FilePickerViewController.load(filename: filename),
            let buttonActions = try? JSONDecoder().decode([GameControllerButtonAction].self, from: jsonData) {
            
            self.buttonActions = buttonActions
            self.isModified = false
            self.actionsFilename = filename
        }
        else {
            
            let alert = UIAlertController(title: "Could not load \(filename)", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func filePickerViewController(_ filePickerViewController: FilePickerViewController, didSelectFile file: URL) {
        print("file: \(file.path)")
        filePickerViewController.dismiss(animated: true, completion: nil)
        if filePickerViewController.identifier == "loadActions" {
            let filename = file.lastPathComponent
            loadActions(filename: filename)
        }
    }
    
    func loadLastActionsFile() {
        
        if let filename = UserDefaults.standard.string(forKey: "actionsFilename") {
            loadActions(filename: filename)
        }
    }
    
}

//MARK: - TableView
extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameControllerButton.allButtons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let button = GameControllerButton.allButtons[indexPath.row]
        let cell = ButtonCell.dequeue(for: tableView, at: indexPath)
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
        vc.pressedActions       = self.buttonActions(for: button, event: .pressed, copy: true)
        vc.releasedActions      = self.buttonActions(for: button, event: .released, copy: true)
        vc.valueChangedActions  = self.buttonActions(for: button, event: .valueChanged, copy: true)
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
}

//MARK: - ButtonActionsViewControllerDelegate
extension MainViewController: ButtonActionsViewControllerDelegate {
    
    func buttonActionsViewController(_ buttonActionsViewController: ButtonActionsViewController, shouldSaveActionsFor button: GameControllerButton) {
        
        self.isModified = true
        
        removeButtonActions(for: button)
        buttonActions.append(contentsOf: buttonActionsViewController.pressedActions)
        buttonActions.append(contentsOf: buttonActionsViewController.releasedActions)
        buttonActions.append(contentsOf: buttonActionsViewController.valueChangedActions)
        
        self.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Buttons
extension MainViewController {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var keyCommands: [UIKeyCommand]? {
        
        var keyCommands = [UIKeyCommand]()
        keyCommands.append(contentsOf: ICade.pressCommands(action: #selector(keyPressed(sender:))))
        keyCommands.append(contentsOf: ICade.releaseCommands(action: #selector(keyReleased(sender:))))
        
        return keyCommands
    }
    
    @objc func keyReleased(sender: UIKeyCommand) {
        
        self.becomeFirstResponder()
        guard let button = ICadeButton.button(forReleaseKey: sender.input!) else { print("Unknown key: \(String(describing: sender.input))"); return }
        onButton(button, pressed: false)
    }
    
    @objc func keyPressed(sender: UIKeyCommand) {
        
        self.becomeFirstResponder()
        guard let button = ICadeButton.button(forPressKey: sender.input!) else { print("Unknown key: \(String(describing: sender.input))"); return }
        onButton(button, pressed: true)
    }
    
    
    func buttonActions(for button: GameControllerButton, event: GameControllerButton.Event, copy: Bool = false) -> [GameControllerButtonAction] {
        
        var actions = [GameControllerButtonAction]()
        for buttonAction in buttonActions {
            if buttonAction.button == button && buttonAction.event == event {
                
                if copy {
                    if let buttonActionCopy = buttonAction.copy() {
                        actions.append(buttonActionCopy)
                    }
                }
                else {
                    actions.append(buttonAction)
                }
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
                
                self.playSound(filename: action.filename, loop: action.loop)
            }
            else if let action = action as? StopSoundAction {
                
                self.stopSound(filename: action.filename)
            }
            else if let action = action as? DriveAction {
                
                guard let sbrick = self.sbrick else { continue }
                sbrick.managedPort(for: action.port).drive(power: action.power, isCW: action.isCW)
            }
            else if let action = action as? StopAction {
                
                guard let sbrick = self.sbrick else { continue }
                sbrick.managedPort(for: action.port).stop()
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
                    sbrick.managedPort(for: action.port).stop()
                }
                else {
                    let isCW = power.isNegative ? !action.isCW : action.isCW
                    sbrick.managedPort(for: action.port).drive(power: power.value, isCW: isCW)
                }
            }
        }
    }
}


