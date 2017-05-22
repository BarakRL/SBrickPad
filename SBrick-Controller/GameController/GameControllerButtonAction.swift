//
//  GameControllerButtonAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/22/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import JSONCodable

class GameControllerButtonAction: JSONCodable, JSONDecodable, CustomStringConvertible {
    
    var button: GameControllerButton
    var action: GameControllerAction
    var event: GameControllerButton.Event
    
    init(button: GameControllerButton, action: GameControllerAction, forEvent event: GameControllerButton.Event) {
        self.button = button
        self.action = action
        self.event = event
    }
    
    required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.button = try decoder.decode("button")
        self.event = try decoder.decode("event")
        
        guard let actionObject = object["action"] as? JSONObject else {
            throw GameControllerActionLoaderError.UnknownAction
        }
        
        self.action = try GameControllerActionLoader.action(from: actionObject)
    }
    
    var description: String { return "On \(button) \(event): \(action)" }
}
