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
    
    var imageActual: UIImage? {
        get {
            if self.image != nil {
                if image?.imageBig != nil {
                    return UIImage(data: self.image!.imageBig! as Data)
                }
            }
            return nil
        }
        set {
            if newValue == nil {
                if self.image != nil {
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!)
                }
                self.imageSmall = nil
            }
            else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                }
                self.image?.imageBig = newValue?.jpegData(compressionQuality: 1) as NSData?
                self.imageSmall = newValue?.jpegData(compressionQuality: 0.05) as NSData?
            }
            dateUpdate = NSDate()
        }
    }
    
    var locationActual: LocationCoordinate? {
        get {
            if self.location == nil {
                return nil
            }
            else {
                return LocationCoordinate(latitude: self.location!.latitude, longitude: self.location!.longitude)
            }
        }
        set {
            if newValue == nil, self.location != nil {
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
            }
            if newValue != nil, self.location == nil {
                let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                location.latitude = newValue!.latitude
                location.longitude = newValue!.longitude
                self.location = location
            }
            if newValue != nil, self.location != nil {
                self.location!.latitude = newValue!.latitude
                self.location!.longitude = newValue!.longitude
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.sharedInstance.getCurrentLocation { (location) in
            self.locationActual = location
            print("Установлена новая локация: \(location)")
        }
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
