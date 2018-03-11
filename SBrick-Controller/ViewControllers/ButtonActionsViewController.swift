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
    
    let sectionPressed = 0
    let sectionReleased = 1
    let sectionValueChanged = 2
    
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
        
        let event = self.event(forSection: section)
        let buttonActions = self.buttonActions(for: event)
        
        return buttonActions.count > 0 ? buttonActions.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = self.event(forSection: indexPath.section)
        let buttonActions = self.buttonActions(for: event)
        
        let cell = ActionCell.dequeue(for: tableView, at: indexPath)
        if indexPath.row < buttonActions.count {
            cell.action = buttonActions[indexPath.row].action
        }
        else {
            cell.action = nil
        }
        
        return cell
    }
    
    private func buttonActions(for event: GameControllerButton.Event) -> [GameControllerButtonAction] {
        
        switch event {
        case .pressed:      return self.pressedActions
        case .released:     return self.releasedActions
        case .valueChanged: return self.valueChangedActions
        }
    }
    
    func event(forSection section: Int) -> GameControllerButton.Event {
        
        switch section {
        case sectionPressed:      return .pressed
        case sectionReleased:     return .released
        case sectionValueChanged: return .valueChanged
            
        default: fatalError("Unknown section")
        }
    }
    
    private func set(buttonActions: [GameControllerButtonAction], for event: GameControllerButton.Event)  {
        
        switch event {
        case .pressed:
            self.pressedActions = buttonActions
            
        case .released:
            self.releasedActions = buttonActions
            
        case .valueChanged:
            self.valueChangedActions = buttonActions
        }
    }

    func addButtonAction(to event: GameControllerButton.Event) {
        
        let action = StopSoundAction() //TO DO: select action
        
        var buttonActions = self.buttonActions(for: event)
        let buttonAction = GameControllerButtonAction(button: self.button, action: action, forEvent: event)
        buttonActions.append(buttonAction)
        set(buttonActions: buttonActions, for: event)
        
        tableView.reloadData()
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
        
        let event = self.event(forSection: section)
        let header = ActionHeaderView(event: event)        
        header.titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        header.onAddButtonPressed = { [weak self] actionHeader in
            
            self?.addButtonAction(to: actionHeader.event)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let event = self.event(forSection: indexPath.section)
        let buttonActions = self.buttonActions(for: event)
        
        return (indexPath.row < buttonActions.count)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            
            let event = self.event(forSection: indexPath.section)
            var buttonActions = self.buttonActions(for: event)
            
            buttonActions.remove(at: indexPath.row)
            set(buttonActions: buttonActions, for: event)
            
            if buttonActions.count > 0 {
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
        
        let event = self.event(forSection: indexPath.section)
        let buttonActions = self.buttonActions(for: event)
        
        if indexPath.row < buttonActions.count {
            
            let action = buttonActions[indexPath.row].action
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
