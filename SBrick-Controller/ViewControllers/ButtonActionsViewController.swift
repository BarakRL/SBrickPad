//
//  ButtonActionsViewController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 5/1/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class ButtonActionsViewController: UITableViewController {
    
    var button: GameControllerButton!
    
    var pressAction: GameControllerPressAction?
    var releaseAction: GameControllerPressAction?
    var valueAction: GameControllerValueAction?
    
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var action: GameControllerAction?
        switch indexPath.section {
        case 0:
            action = self.pressAction
        
        case 1:
            action = self.releaseAction
            
        case 2:
            action = self.valueAction
            
        default:
            break
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionCell.reuseIdentifier, for: indexPath) as! ActionCell
        cell.action = action
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
           return "Press Action"
            
        case 1:
            return "Release Action"
            
        case 2:
            return "Value Action"
            
        default:
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TBD
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        //TO DO: notify delegate
        dismiss()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        //TO DO: notify delegate
        dismiss()
    }
    
    private func dismiss() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
