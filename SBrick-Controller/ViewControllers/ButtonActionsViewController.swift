//
//  ButtonActionsViewController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

protocol ButtonActionsViewControllerDelegate: class {
    
    func buttonActionsViewController(_ buttonActionsViewController: ButtonActionsViewController, shouldSaveActionsFor button: GameControllerButton)
}

class ButtonActionsViewController: UITableViewController {
    
    weak var delegate: ButtonActionsViewControllerDelegate?
    
    var button: GameControllerButton!
    
    var pressedActions: [GameControllerAction]!
    var releasedActions: [GameControllerAction]!
    var valueChangedActions: [GameControllerAction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let actions = self.actions(forSection: section)
        return actions.count > 0 ? actions.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let actions = self.actions(forSection: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionCell.reuseIdentifier, for: indexPath) as! ActionCell
        if indexPath.row < actions.count {
            cell.action = actions[indexPath.row]
        }
        else {
            cell.action = nil
        }
        
        return cell
    }
    
    private func actions(forSection section: Int) -> [GameControllerAction] {
        
        switch section {
        case 0:
            return self.pressedActions
            
        case 1:
            return self.releasedActions
            
        case 2:
            return self.valueChangedActions
            
        default:
            fatalError("Unknown section")
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
           return "On Press"
            
        case 1:
            return "On Release"
            
        case 2:
            return "On Value Change"
            
        default:
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        self.delegate?.buttonActionsViewController(self, shouldSaveActionsFor: self.button)
    }
}
