//
//  GameControllerAction.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/30/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

//extension UInt8: JSONCompatible {}

protocol GameControllerAction: Codable, CustomStringConvertible {
    
    var type: String { set get } //required for encode and decode match, should always be = 'Self'.type
    var name: String { get }
    var info: String { get }
    
    var editCellsCount: Int { get }
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type
    func bind(to editCell: GameControllerActionEditCell, at index: Int)    
}

extension GameControllerAction {
    static var type: String { return String(describing: self) }
    
    //defaults
    var editCellsCount: Int { return 0 }
    func editCellType(at index: Int) -> GameControllerActionEditCell.Type { return GameControllerActionEditCell.self }
    func bind(to editCell: GameControllerActionEditCell, at index: Int) { }
}

extension GameControllerAction {
    var description: String { return "\(name) (\(info))" }
}

protocol PresentationDelegate: class {
    
    func present(_ viewController: UIViewController)    
}

class GameControllerActionEditCell: UITableViewCell {
    
    weak var presentationDelegate: PresentationDelegate?
    var onChange: (() -> ()) = {}
    var identifier: String = ""
    
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
