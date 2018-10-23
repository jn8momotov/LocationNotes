//
//  Folder+CoreDataClass.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {

    class func newFolder(name: String) -> Folder {
        let folder = Folder(context: CoreDataManager.sharedInstance.managedObjectContext)
        folder.name = name
        folder.dateUpdate = NSDate()
        return folder
    }
    
    func addNote() -> Note {
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        note.folder = self
        note.dateUpdate = NSDate()
        return note
    }
    
}
