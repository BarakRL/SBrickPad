//
//  GameControllerPressAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import SBrick

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
    
    var editCells: [GameControllerActionEditCell.Type] {
        return [SelectSoundEditCell.self]
    }
    
    func bind(to editCell: GameControllerActionEditCell) {
                
        if let cell = editCell as? SelectSoundEditCell {
            
            cell.fileName = self.fileName
            cell.loop = self.loop
            
            cell.onChange = {
                
                self.fileName = cell.fileName
                self.loop = cell.loop
            }            
        }
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
}

class DriveAction: GameControllerPressAction {
    
    var port: SBrickPort
    var power: UInt8
    var isCW: Bool
    
    var type: String = DriveAction.type
    var name: String { return "Drive" }
    var info: String { return "Port: \(port), Power: \(power) \(isCW ? "CW" : "CCW")" }
    
    init(port: SBrickPort, power: UInt8, isCW: Bool) {
        self.port = port
        self.power = power
        self.isCW = isCW
    }
}

class StopAction: GameControllerPressAction {
    
    var port: SBrickPort
    
    var type: String = StopAction.type
    var name: String { return "Stop" }
    var info: String { return "Port: \(port)" }
    
    init(port: SBrickPort) {
        self.port = port
    }
}

