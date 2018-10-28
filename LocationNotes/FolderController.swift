//
//  FolderController.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class FolderController: UITableViewController {

    var folder: Folder?
    
    var notesActual: [Note] {
        if let folder = folder {
            return folder.notesSorted
        }
        return notes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let folder = folder {
            navigationItem.title = folder.name
        }
        else {
            navigationItem.title = "All notes".localize()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var selectedNote: Note?
    
    @IBAction func addNoteBarButtonPressed(_ sender: UIBarButtonItem) {
        selectedNote = Note.newNote(name: "", in: folder)
        selectedNote?.addCurrentLocation()
        performSegue(withIdentifier: "segueToNote", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesActual.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellNote", for: indexPath) as! NoteCell
        cell.initCell(for: notesActual[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNote = notesActual[indexPath.row]
        performSegue(withIdentifier: "segueToNote", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.sharedInstance.managedObjectContext.delete(notesActual[indexPath.row])
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert { }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToNote":
            (segue.destination as? NoteController)?.note = selectedNote
        default:
            return
        }
    }

}
