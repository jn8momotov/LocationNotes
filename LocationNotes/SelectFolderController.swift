//
//  SelectFolderController.swift
//  LocationNotes
//
//  Created by Евгений on 24/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class SelectFolderController: UITableViewController {

    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSelectFolder", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "No selected".localize()
            if note?.folder == nil {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        else {
            let folder = folders[indexPath.row - 1]
            cell.textLabel?.text = folder.name
            if folder == note?.folder {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            note?.folder = nil
        }
        else {
            note?.folder = folders[indexPath.row - 1]
        }
        tableView.reloadData()
    }

}
