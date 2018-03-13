//
//  ButtonActionsViewController.swift
//  SBrickPad
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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        saveButton.setTitleTextAttributes([.foregroundColor: #colorLiteral(red: 0.9917162061, green: 0.8454038501, blue: 0.003790777875, alpha: 1), .font: UIFont.gillSans(size: 18)], for: .normal)
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        navigationItem.title = button.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = UIColor.groupTableViewBackground
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
    
    private func event(forSection section: Int) -> GameControllerButton.Event {
        
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

    private func actions(for event: GameControllerButton.Event) -> [GameControllerAction] {
        
        switch event {
        case .pressed, .released:
            return [DriveAction(), StopAction(), PlaySoundAction(), StopSoundAction()]
        
        case .valueChanged:
            return [DriveValueAction()]
        }        
    }
    
    private func promptAddAction(to event: GameControllerButton.Event) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for action in self.actions(for: event) {
    
            actionSheet.addAction(UIAlertAction(title: action.name, style: .default, handler: { [weak self] _ in
                self?.addButtonAction(action, to: event)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func addButtonAction(_ action: GameControllerAction, to event: GameControllerButton.Event) {
        
        let buttonAction = GameControllerButtonAction(button: self.button, action: action, forEvent: event)
        
        var buttonActions = self.buttonActions(for: event)
        buttonActions.append(buttonAction)
        self.set(buttonActions: buttonActions, for: event)
        
        self.tableView.reloadData()
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
            self?.promptAddAction(to: actionHeader.event)
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
