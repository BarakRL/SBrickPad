//
//  GameControllerPressAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import JSONCodable

protocol GameControllerPressAction: GameControllerAction {
}

//MARK: - Actions -

class PlaySoundAction: GameControllerPressAction {
    
    var fileName: String
    var loop: Bool
    
    var type: String = PlaySoundAction.type
    var name: String { return "Play Sound" }
    var info: String { return "\(fileName)\(loop ? " (loop)" : "")" }
    
    init(fileName: String, loop: Bool) {
        self.fileName = fileName
        self.loop = loop
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.fileName = try decoder.decode("fileName")
        self.loop = try decoder.decode("loop")
    }
}

class StopSoundAction: GameControllerPressAction {
    
    var fileName: String
    
    var type: String = StopSoundAction.type
    var name: String { return "Stop Sound" }
    var info: String { return fileName }
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.fileName = try decoder.decode("fileName")        
    }
}

class DriveAction: GameControllerPressAction {
    
    var channel: UInt8
    var power: UInt8
    var isCW: Bool
    
    var type: String = DriveAction.type
    var name: String { return "Drive" }
    var info: String { return "Channel: \(channel), Power: \(power) \(isCW ? "CW" : "CCW")" }
    
    init(channel: UInt8, power: UInt8, isCW: Bool) {
        self.channel = channel
        self.power = power
        self.isCW = isCW
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.channel = try decoder.decode("channel")
        self.power = try decoder.decode("power")
        self.isCW = try decoder.decode("isCW")
    }
}

class StopAction: GameControllerPressAction {
    
    var channel: UInt8
    
    var type: String = StopAction.type
    var name: String { return "Stop" }
    var info: String { return "Channel: \(channel)" }
    
    init(channel: UInt8) {
        self.channel = channel
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.channel = try decoder.decode("channel")
    }
}

