//
//  NoteController.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NoteController: UITableViewController {

    var note: Note?
    
    @IBOutlet weak var imageNote: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var nameFolderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = note?.name
        descriptionText.text = note?.textDescription
        imageNote.image = note?.imageActual
        navigationItem.title = note?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder {
            nameFolderLabel.text = folder.name
        }
        else {
            nameFolderLabel.text = "-"
        }
    }
    
    @IBAction func saveNoteBarButtonPressed(_ sender: UIBarButtonItem) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    func saveNote() {
        if nameTextField.text == "", descriptionText.text == "", imageNote.image == nil {
            CoreDataManager.sharedInstance.managedObjectContext.delete(note!)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        if nameTextField.text != note?.name || descriptionText.text != note?.textDescription {
            note?.dateUpdate = NSDate()
        }
        note?.name = nameTextField.text
        note?.textDescription = descriptionText.text
        note?.imageActual = imageNote.image
        CoreDataManager.sharedInstance.saveContext()
    }

    // MARK: - Table view data source

    let imagePicker = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0, indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let libraryAction = UIAlertAction(title: "Select from library", style: .default) { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let takePhotoAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(libraryAction)
            alertController.addAction(takePhotoAction)
            if imageNote.image != nil {
                let deleteAction = UIAlertAction(title: "Delete photo", style: .destructive) { (action) in
                    self.imageNote.image = nil
                }
                alertController.addAction(deleteAction)
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueToSelectFolder":
            (segue.destination as! SelectFolderController).note = note
        case "segueToNoteMap":
            (segue.destination as! NoteMapController).note = note
        default:
            return
        }
    }

}

extension NoteController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageNote.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
