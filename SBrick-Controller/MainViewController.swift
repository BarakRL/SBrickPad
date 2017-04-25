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

class MainViewController: UITableViewController, SBrickManagerDelegate, SBrickDelegate {

    var manager: SBrickManager!
    var sbrick: SBrick?
    
    let driveChannel: UInt8 = 2
    let steerChannel: UInt8 = 0
    let steerCW: Bool = true
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SBrick iCade"
        
        tableView.allowsMultipleSelection = true
        
        manager = SBrickManager(delegate: self)
        
        statusLabel.text = "Discovering..."
        manager.startDiscovery()
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
}

extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ICadeButton.allButtons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let button = ICadeButton.allButtons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = button.name
        cell.detailTextLabel?.text = "No action"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TBD
        tableView.deselectRow(at: indexPath, animated: true)
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
        guard let button = ICadeButton(key: sender.input) else { print("Unknown key: \(sender.input)"); return }
        onButton(button, pressed: false)
    }
    
    func keyPressed(sender: UIKeyCommand) {
        
        self.becomeFirstResponder()
        guard let button = ICadeButton(key: sender.input) else { print("Unknown key: \(sender.input)"); return }
        onButton(button, pressed: true)
    }
    
    
    func onButton(_ button: ICadeButton, pressed: Bool) {
        
        print("\(button) \(pressed ? "pressed" : "released")")
        
        if let index = ICadeButton.allButtons.index(of: button) {
            let indexPath = IndexPath(row: index, section: 0)
            if pressed {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
            else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }        
        
        guard let sbrick = self.sbrick else { return }
        
        switch button {
        
        case .left:
            
            if pressed {
                 sbrick.send(command: .drive(channelId: steerChannel, cw: steerCW, power: 255))
            }
            else {
                sbrick.send(command: .stop(channelId: steerChannel))
            }
           
            
        case .right:
            
            if pressed {
                sbrick.send(command: .drive(channelId: steerChannel, cw: !steerCW, power: 255))
            }
            else {
                sbrick.send(command: .stop(channelId: steerChannel))
            }
            
        case .button1:
            
            if pressed {
                sbrick.send(command: .drive(channelId: driveChannel, cw: false, power: 0xFF))
            }
            else {
                sbrick.send(command: .stop(channelId: driveChannel))
            }
            
        case .button2:
            
            if pressed {
                accPower = 100
                accTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self] (timer) in
                    if self.accPower < 0xFF {
                        self.accPower = UInt8(min(Int(self.accPower) + 10, 0xFF))
                        sbrick.send(command: .drive(channelId: self.driveChannel, cw: false, power: self.accPower))
                    }
                })
            }
            else {
                sbrick.send(command: .stop(channelId: driveChannel))
                accTimer?.invalidate()
            }
            
        case .button3:
            
            if pressed {
                sbrick.send(command: .drive(channelId: driveChannel, cw: true, power: 0xFF))
            }
            else {
                sbrick.send(command: .stop(channelId: driveChannel))
            }
            
        case .button4:
            
            if pressed {
                accPower = 100
                accTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self] (timer) in
                    if self.accPower < 0xFF {
                        self.accPower = UInt8(min(Int(self.accPower) + 10, 0xFF))
                        sbrick.send(command: .drive(channelId: self.driveChannel, cw: true, power: self.accPower))
                    }
                })
            }
            else {
                sbrick.send(command: .stop(channelId: driveChannel))
                accTimer?.invalidate()
            }
            
        case .button5:
            
            if pressed {
                playSound(name: "horn", withExtension: "wav")
            }
            else {
                stopSound()
            }
        
        case .button6:
            
            
            if pressed {
                playSound(name: "engine", withExtension: "mp3")
            }
            else {
                stopSound()
            }
            
        default:
            break
        }
        
    }
    
}





extension MainViewController {
    
    /*
    enum State {
        case idle
        case driving
        case stopped
        case reversing
    }
    
    var didReverseCW = false
    var state = State.idle {
     
        didSet {
     
            guard let sbrick = self.sbrick else { return }
            
            switch state {
                
            case .idle:
                sbrick.send(command: .stop(channelId: 0x02))
                sbrick.send(command: .stop(channelId: 0x03))
                
            case .driving:
                self.didReverseCW = false
                sbrick.send(command: .drive(channelId: 0x02, cw: false, power: 255))
                
            case .stopped:
                sbrick.send(command: .stop(channelId: 0x02))
                
            case .reversing:
                self.didReverseCW = !self.didReverseCW
                sbrick.send(command: .stop(channelId: 0x02))
                sbrick.send(command: .drive(channelId: 0x03, cw: didReverseCW, power: 255))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    sbrick.send(command: .drive(channelId: 0x02, cw: true, power: 255))
                })
                
            }
        }
        
    }
    
    
    var adcTimer: Timer?
    func startAutodrive() {
        
        guard let sbrick = self.sbrick else { return }
        
        sbrick.send(command: .write(bytes: [0x2C,0x01]))
        
        adcTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            
            guard let _self = self else { return }
            guard let sbrick = _self.manager.sbricks.first else { return }
            
            
            sbrick.send(command: .queryADC(channelId: 0x01)) { (bytes) in
                
                let adcValue = bytes.uint16littleEndianValue()/16
                
                print("ADC 01: \(adcValue)")
                
                if adcValue > 250 && _self.state == .idle {
                    _self.state = .driving
                    
                }
                else if adcValue < 250 && _self.state != .reversing {
                    _self.state = .reversing
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        _self.state = .idle
                    })
                }
            }
        })
    }
    */
    
}
