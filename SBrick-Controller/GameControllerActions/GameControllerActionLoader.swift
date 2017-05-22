//
//  GameControllerActionLoader.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/21/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import JSONCodable

enum GameControllerActionLoaderError: Error {
    case UnknownAction
}

class GameControllerActionLoader {
    
    static func buttonActions(from object: [String: JSONObject]) -> [GameControllerButton: GameControllerAction] {
        
        var buttonActions = [GameControllerButton: GameControllerAction]()        
        for (key,value) in object {
            
            if let button =  GameControllerButton(rawValue: key),
                let action = self.action(from: value) {
                
                buttonActions[button] = action
            }
        }
        
        return buttonActions
     }
    
    //MARK: - Helpers
    
    static func action(from object: JSONObject) -> GameControllerAction? {
        
        do {
            let decoder = JSONDecoder(object: object)
            let type: String = try decoder.decode("type")
            
            if let actionClass = self.actionClass(forType: type) {
                return try actionClass.init(object: object)
            }
        }
        catch {
            print("JSON Error: \(error)")
        }
        
        return nil
    }
    
    static func object(from JSONString: String) -> JSONObject? {
        
        guard let data = JSONString.data(using:String.Encoding.utf8) else {
            return nil
        }
        
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: [])
            return result as? JSONObject
        }
        catch {
            return nil
        }
    }
    
    //MARK: - Known Actions
    static func actionClass(forType type: String) -> GameControllerAction.Type? {
        
        switch type {
            
        //press actions
        case PlaySoundAction.type:
            return PlaySoundAction.self
            
        case StopSoundAction.type:
            return StopSoundAction.self
            
        case DriveAction.type:
            return DriveAction.self
            
        case StopAction.type:
            return StopAction.self
            
        //value actions
        case DriveValueAction.type:
            return DriveValueAction.self
            
        default:
            return nil
        }
        
    }
    
    
    
}
