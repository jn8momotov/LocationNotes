//
//  FoldersController.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class FoldersController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.requestAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func addFolderBarButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Create new folder".localize(), message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Folder name".localize()
        }
        let actionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        let actionAdd = UIAlertAction(title: "Create".localize(), style: .default) { (alert) in
            let text = alertController.textFields?[0].text
            if text != "" {
                _ = Folder.newFolder(name: text!.uppercased())
                CoreDataManager.sharedInstance.saveContext()
                self.tableView.reloadData()
            }
        }
        alertController.addAction(actionCancel)
        alertController.addAction(actionAdd)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFolder", for: indexPath)
        let folder = folders[indexPath.row]
        cell.textLabel?.text = folder.name
        cell.detailTextLabel?.text = "\(folder.notes?.count ?? 0) " + "items".localize()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toListNotes", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.sharedInstance.managedObjectContext.delete(folders[indexPath.row])
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert { }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toListNotes":
            let controller = segue.destination as? FolderController
            let folder = folders[tableView.indexPathForSelectedRow!.row]
            controller?.folder = folder
        default:
            return
        }
    }

}
