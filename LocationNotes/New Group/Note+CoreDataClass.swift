//
//  Note+CoreDataClass.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Note)
public class Note: NSManagedObject {

    class func newNote(name: String, in folder: Folder?) -> Note {
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        note.name = name
        note.dateUpdate = NSDate()
        if let folder = folder {
            note.folder = folder
        }
        return note
    }
    
    func addImage(image: UIImage) {
        let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
        imageNote.imageBig = image.jpegData(compressionQuality: 1) as NSData?
        self.image = imageNote
    }
    
    func addLocation(latitude: Double, longitude: Double) {
        let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.latitude = latitude
        location.longitude = longitude
        self.location = location
    }
    
    var dateUpdateString: String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .short
        return dateFormat.string(from: self.dateUpdate! as Date)
    }
    
}
