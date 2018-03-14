//
//  GameControllerPressAction.swift
//  SBrickPad
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
    
    static var type: String { return "play_sound" }
    
    var filename: String?
    var loop: Bool = false
    
    var type: String = PlaySoundAction.type
    var name: String { return "Play Sound" }
    var info: String { return "\(filename ?? "(none)"), Loop: \(loop ? "Yes" : "No")" }
    
    var editCellsCount: Int { return 2 }
    
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        
        switch index {
        case 0: return SelectSoundEditCell.self
        case 1: return SwitchEditCell.self
        default: fatalError()
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
    
    static var type: String { return "stop_sound" }
    
    var filename: String?
    
    var type: String = StopSoundAction.type
    var name: String { return "Stop Sound" }
    var info: String { return filename ?? "All Sounds" }
    
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
    
    static var type: String { return "drive" }
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case port
        case power
        case isCW       = "is_cw"
        case isToggle   = "is_toggle"
    }
    
    //parameters
    var port: SBrickPort = .port1
    var power: UInt8 = UInt8.max
    var isCW: Bool = true
    var isToggle: Bool = false
    
    var type: String = DriveAction.type
    var name: String { return "Drive" }
    var info: String { return "Port: \(port.rawValue), \(isToggle ? "Toggle:" : "Power:") \(power) \(isCW ? "CW" : "CCW")" }
    
    var editCellsCount: Int { return 4 }
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        switch index {
        case 0: return SegmentedControlEditCell.self
        case 1: return SliderEditCell.self
        case 2: return SwitchEditCell.self
        case 3: return SwitchEditCell.self
        default: fatalError()
        }
    }
    
    func bind(to editCell: GameControllerActionEditCell, at index: Int) {
        
        switch index {
        case 0:
            guard let cell = editCell as? SegmentedControlEditCell else { return }
            
            cell.title = "Port:"
            cell.values = ["1", "2", "3", "4"]
            cell.selectedSegmentIndex = self.port.rawValue - 1
            
            cell.onChange = {
                if let port = SBrickPort(rawValue: cell.selectedSegmentIndex + 1) {
                    self.port = port
                }
            }
            
        case 1:
            guard let cell = editCell as? SliderEditCell else { return }
            
            cell.title = "Power:"
            cell.value = self.power
            
            cell.onChange = {
                self.power = cell.value
            }
            
        case 2:
            guard let cell = editCell as? SwitchEditCell else { return }
            cell.title = "Clockwise:"
            cell.isOn = self.isCW
            cell.onChange = {
                self.isCW = cell.isOn
            }
            
        case 3:
            guard let cell = editCell as? SwitchEditCell else { return }
            cell.title = "Toggle:"
            cell.isOn = self.isToggle
            cell.onChange = {
                self.isToggle = cell.isOn
            }
            
        default:
            break
        }
    }
}

class StopAction: GameControllerPressAction {
    
    static var type: String { return "stop" }
    
    var port: SBrickPort = .port1
    
    var type: String = StopAction.type
    var name: String { return "Stop" }
    var info: String { return "Port: \(port.rawValue)" }
    
    var editCellsCount: Int { return 1 }
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        switch index {
        case 0: return SegmentedControlEditCell.self
        default: fatalError()
        }
    }
    
    func bind(to editCell: GameControllerActionEditCell, at index: Int) {
        
        switch index {
        case 0:
            guard let cell = editCell as? SegmentedControlEditCell else { return }
            
            cell.title = "Port:"
            cell.values = ["1", "2", "3", "4"]
            cell.selectedSegmentIndex = self.port.rawValue - 1
            
            cell.onChange = {
                if let port = SBrickPort(rawValue: cell.selectedSegmentIndex + 1) {
                    self.port = port
                }
            }
            
        default:
            break
        }
    }
}

