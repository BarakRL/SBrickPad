//
//  GameControllerButtonActionSet.swift
//  SBrickPad
//
//  Created by Barak Harel on 3/13/18.
//  Copyright © 2018 Barak Harel. All rights reserved.
//

import Foundation

class GameControllerButtonActionSet: Codable {
    
    static let currentVersion: Int = 1

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case buttonActions = "button_actions"
    }
    
    var version: Int = 0
    var buttonActions: [GameControllerButtonAction]
    
    init(buttonActions: [GameControllerButtonAction]) {
        self.version = GameControllerButtonActionSet.currentVersion
        self.buttonActions = buttonActions
    }    
}
