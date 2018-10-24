//
//  CoreDataManager.swift
//  LocationNotes
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreData

var folders: [Folder] {
    let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    let array = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
    if array != nil {
        return array!
    }
    return []
}

var notes: [Note] {
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateUpdate", ascending: false)]
    let array = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
    if array != nil {
        return array!
    }
    return []
}

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocationNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
