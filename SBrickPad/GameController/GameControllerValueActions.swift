//
//  GameControllerValueActions.swift
//  SBrickPad
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import SBrick

protocol GameControllerValueAction: GameControllerAction {
}

//MARK: - Actions -

class DriveValueAction: GameControllerValueAction {
    
    static var type: String { return "drive_value" }
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case port
        case minPower   = "min_power"
        case maxPower   = "max_power"
        case isCW       = "is_cw"
        case easing
    }
    
    var port: SBrickPort = .port1
    var minPower: UInt8 = UInt8.min
    var maxPower: UInt8 = UInt8.max
    var isCW: Bool = true
    var easing: GameControllerValueActionEasing = .linear
    
    var type: String = DriveValueAction.type
    var name: String { return "Drive Motor" }
    var info: String { return "Port: \(self.port), Power: \(self.minPower)-\(self.maxPower) \(self.isCW ? "CW" : "CCW")" }
    
    func relativePower(fromValue inValue: Float) -> (value: UInt8, isNegative: Bool) {
        return self.relativeValue(fromValue: inValue, minOutValue: minPower, maxOutValue: maxPower, easing: easing)
    }
    
    var editCellsCount: Int { return 5 }
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type {
        switch index {
        case 0: return SegmentedControlEditCell.self
        case 1: return SliderEditCell.self
        case 2: return SliderEditCell.self
        case 3: return SwitchEditCell.self
        case 4: return SegmentedControlEditCell.self
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
            
            cell.title = "Min Power:"
            cell.value = self.minPower
            
            cell.onChange = {
                if cell.value > self.maxPower {
                    cell.value = self.maxPower
                }
                self.minPower = cell.value
            }
            
        case 2:
            guard let cell = editCell as? SliderEditCell else { return }
            
            cell.title = "Max Power:"
            cell.value = self.maxPower
            
            cell.onChange = {
                if cell.value < self.minPower {
                    cell.value = self.minPower
                }
                self.maxPower = cell.value
            }
            
        case 3:
            guard let cell = editCell as? SwitchEditCell else { return }
            cell.title = "Clockwise:"
            cell.isOn = self.isCW
            cell.onChange = {
                self.isCW = cell.isOn
            }
            
        case 4:
            guard let cell = editCell as? SegmentedControlEditCell else { return }
            
            cell.title = "Easing:"
            cell.values = GameControllerValueActionEasing.allValues.map { "\($0)" }
            cell.selectedSegmentIndex = GameControllerValueActionEasing.allValues.index(of: self.easing) ?? -1
            
            cell.onChange = {
                
                let easing = GameControllerValueActionEasing.allValues[cell.selectedSegmentIndex]
                self.easing = easing
            }
            
        default:
            break
        }
    }
}

//MARK: - Helpers

extension GameControllerValueAction {
    
    func relativeValue(fromValue inValue: Float, minOutValue: UInt8, maxOutValue: UInt8, easing: GameControllerValueActionEasing) -> (value: UInt8, isNegative: Bool) {
        
        //keep polarity, but calculate as UInt8
        let isNegative: Bool = (inValue < 0)
        let value = easing.curve(abs(inValue))
        
        //print("\(inValue) -> \(isNegative ? "-" : "+")\(value))")
        
        //protect (if min = 100, max = 50 -> min = 50)
        let minOutValue = min(maxOutValue, minOutValue)
        
        //normalize
        let relativeValue = UInt(Float(maxOutValue - minOutValue) * value) + UInt(minOutValue)
        
        //protect and cast
        let outValue = UInt8(min(relativeValue, UInt(0xFF)))
        return (value: outValue, isNegative: isNegative)
    }
}
