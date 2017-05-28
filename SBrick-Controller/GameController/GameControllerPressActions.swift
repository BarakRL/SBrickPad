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
    
    var soundName: String
    var ext: String
    
    var type: String = PlaySoundAction.type
    var name: String { return "Play Sound" }
    var info: String { return "\(soundName).\(ext)" }
    
    init(soundName: String, ext: String) {
        self.soundName = soundName
        self.ext = ext
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.soundName = try decoder.decode("soundName")
        self.ext = try decoder.decode("ext")
    }
}

class StopSoundAction: GameControllerPressAction {
    
    var soundName: String
    var ext: String
    
    var type: String = StopSoundAction.type
    var name: String { return "Stop Sound" }
    var info: String { return "\(soundName).\(ext)" }
    
    init(soundName: String, ext: String) {
        self.soundName = soundName
        self.ext = ext
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        self.soundName = try decoder.decode("soundName")
        self.ext = try decoder.decode("ext")
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
