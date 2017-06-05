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
    
    var editCells: [GameControllerActionEditCell.Type] { get }
    func bind(to editCell: GameControllerActionEditCell)
}

extension GameControllerAction {
    static var type: String { return String(describing: self) }
    
    var editCells: [GameControllerActionEditCell.Type] { return [] }
    func bind(to editCell: GameControllerActionEditCell) { }
}

extension GameControllerAction {
    var description: String { return "\(name) (\(info))" }
}

protocol PresentationDelegate: class {
    
    func present(_ viewController: UIViewController)    
}

class GameControllerActionEditCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        return "Cell"
    }
    
    weak var presentationDelegate: PresentationDelegate?
    var onChange: (() -> ()) = {}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        presentationDelegate = nil
        onChange = {}
    }
    
    func setup() {
        self.selectionStyle = .none
    }
}
