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
    
    var filename: String?
    var loop: Bool = false
    
    var type: String = PlaySoundAction.type
    var name: String { return "Play Sound" }
    var info: String { return "\(filename ?? "(none)"), Loop: \(loop ? "Yes" : "No")" }
    
    init() {
        self.filename = nil
        self.loop = false
    }
    
    var editCellsCount: Int { return 2 }
    
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        
        switch index {
        case 0: return SelectSoundEditCell.self
        case 1: return SwitchEditCell.self
        default: return GameControllerActionEditCell.self
        }
    }
    
    func bind(to editCell: GameControllerActionEditCell, at index: Int) {
        
        switch index {
        case 0:
            guard let cell = editCell as? SelectSoundEditCell else { return }
            cell.filename = self.filename
            cell.onChange = {
                self.filename = cell.filename
            }
            
        case 1:
            guard let cell = editCell as? SwitchEditCell else { return }
            cell.title = "Loop:"
            cell.isOn = self.loop
            cell.onChange = {
                self.loop = cell.isOn
            }
            
        default:
            break
        }        
    }
}

class StopSoundAction: GameControllerPressAction {
    
    var filename: String?
    
    var type: String = StopSoundAction.type
    var name: String { return "Stop Sound" }
    var info: String { return filename ?? "All Sounds" }
    
    init() {
        self.filename = nil
    }
    
    var editCellsCount: Int { return 1 }
    
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        return SelectSoundEditCell.self
    }
    
    func bind(to editCell: GameControllerActionEditCell, at index: Int) {
        guard let cell = editCell as? SelectSoundEditCell else { return }
        cell.filename = self.filename
        cell.onChange = {
            self.filename = cell.filename
        }
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

