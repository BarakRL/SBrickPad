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
    
    var pressedActions = [GameControllerButtonAction]()
    var releasedActions = [GameControllerButtonAction]()
    var valueChangedActions = [GameControllerButtonAction]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = button.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
            cell.action = actions[indexPath.row].action
        }
        else {
            cell.action = nil
        }
        
        return cell
    }
    
    private func actions(forSection section: Int) -> [GameControllerButtonAction] {
        
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
    
    private func set(actions: [GameControllerButtonAction], forSection section: Int)  {
        
        switch section {
        case 0:
            self.pressedActions = actions
            
        case 1:
            self.releasedActions = actions
            
        case 2:
            self.valueChangedActions = actions
            
        default:
            fatalError("Unknown section")
        }
    }

    func addAction(toSection section: Int) {
                
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ActionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        header.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        header.section = section
        header.onAddButtonPressed = { [weak self] actionHeader in
            self?.addAction(toSection: actionHeader.section)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let actions = self.actions(forSection: indexPath.section)
        return (indexPath.row < actions.count)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            var actions = self.actions(forSection: indexPath.section)
            actions.remove(at: indexPath.row)
            set(actions: actions, forSection: indexPath.section)
            
            if actions.count > 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else {
                tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actions = self.actions(forSection: indexPath.section)
        if indexPath.row < actions.count {
            
            let action = actions[indexPath.row].action
            let editVC = EditActionViewController(action: action)
            
            navigationController?.pushViewController(editVC, animated: true)
            
        }
        
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        self.delegate?.buttonActionsViewController(self, shouldSaveActionsFor: self.button)
    }
}
