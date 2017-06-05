//
//  EditActionViewController.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 6/3/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

class EditActionViewController: UITableViewController, PresentationDelegate {

    
    init(action: GameControllerAction) {
        
        self.action = action
        super.init(style: .plain)
        
        self.navigationItem.title = action.name
        
        for cellType in action.editCells {
            tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var action: GameControllerAction
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.sectionIndexMinimumDisplayRowCount = 0
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.groupTableViewBackground
        
        navigationItem.backBarButtonItem?.title = nil
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return action.editCells.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = action.editCells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! GameControllerActionEditCell
        
        cell.presentationDelegate = self
        action.bind(to: cell)

        return cell
    }
    
    func present(_ viewController: UIViewController) {
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
}
