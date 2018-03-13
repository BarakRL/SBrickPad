//
//  GameControllerButtonAction.swift
//  SBrickPad
//
//  Created by Barak Harel on 5/22/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation

enum GameControllerButtonActionError: Error {
    case unknownAction
}

class GameControllerButtonAction: Codable, CustomStringConvertible {
    
    enum CodingKeys: String, CodingKey { // declaring our keys
        case button = "button"
        case action = "action"
        case event = "event"
    }
    
    enum ActionKeys: String, CodingKey {
        //we only need type to choose action class
        case type = "type"
    }
    
    func copy() -> Self? {
        
        do {
            let data = try JSONEncoder().encode(self)
            let copy = try JSONDecoder().decode(type(of: self), from: data)
            return copy
        }
        catch {
            return nil
        }        
    }
    
    var button: GameControllerButton
    var action: GameControllerAction
    var event: GameControllerButton.Event
    
    init(button: GameControllerButton, action: GameControllerAction, forEvent event: GameControllerButton.Event) {
        self.button = button
        self.action = action
        self.event = event
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.button = try container.decode(GameControllerButton.self, forKey: .button)
        self.event = try container.decode(GameControllerButton.Event.self, forKey: .event)
        
        let actionContainer = try container.nestedContainer(keyedBy: ActionKeys.self, forKey: .action)
        let actionType = try actionContainer.decode(String.self, forKey: ActionKeys.type)
        
        switch actionType {
            
        //press actions
        case PlaySoundAction.type:
            self.action = try container.decode(PlaySoundAction.self, forKey: .action)
            
        case StopSoundAction.type:
            self.action = try container.decode(StopSoundAction.self, forKey: .action)
            
        case DriveAction.type:
            self.action = try container.decode(DriveAction.self, forKey: .action)
            
        case StopAction.type:
            self.action = try container.decode(StopAction.self, forKey: .action)
            
        //value actions
        case DriveValueAction.type:
            self.action = try container.decode(DriveValueAction.self, forKey: .action)
            
        default:
            throw GameControllerButtonActionError.unknownAction
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(button, forKey: .button)
        try container.encode(event, forKey: .event)
        
        switch action.type {
            
        //press actions
        case PlaySoundAction.type:
            try container.encode(action as? PlaySoundAction, forKey: .action)
            
        case StopSoundAction.type:
            try container.encode(action as? StopSoundAction, forKey: .action)
            
        case DriveAction.type:
            try container.encode(action as? DriveAction, forKey: .action)
            
        case StopAction.type:
            try container.encode(action as? StopAction, forKey: .action)
            
        //value actions
        case DriveValueAction.type:
            try container.encode(action as? DriveValueAction, forKey: .action)
            
        default:
            throw GameControllerButtonActionError.unknownAction
        }
    }
    
    var description: String { return "On \(button) \(event): \(action)" }
}
