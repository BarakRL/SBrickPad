//
//  GameControllerAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import Foundation
import JSONCodable

extension UInt8: JSONCompatible {}

protocol GameControllerAction: JSONCodable, JSONDecodable, CustomStringConvertible {
    
    var type: String { set get } //required for encode and decode match, should always be = 'Self'.type
    var name: String { get }
    var info: String { get }
}

extension GameControllerAction {
    static var type: String { return String(describing: self) }
}

extension GameControllerAction {
    var description: String { return "\(name) (\(info))" }
}
