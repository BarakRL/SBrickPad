//
//  ActionParametersViewController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ActionParameter {
    
    let cellReuseIdentifier: String
    let data: Any?
    let onCellSelect: (UITableView, UITableViewCell?, IndexPath)->Void
    
    init(cellReuseIdentifier: String, data: Any?, onCellSelect: @escaping (UITableView, UITableViewCell?, IndexPath)->Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.data = data
        self.onCellSelect = onCellSelect
    }
}

class ActionParameterCell: UITableViewCell {
    
    var data: Any?
    
}

class ActionParametersViewController: UITableViewController {

    var parameters: [ActionParameter]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let parameter = self.parameters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: parameter.cellReuseIdentifier, for: indexPath) as! ActionParameterCell
        cell.data = parameter.data
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let parameter = self.parameters[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        parameter.onCellSelect(tableView, cell, indexPath)
        
    }
}
