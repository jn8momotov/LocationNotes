//
//  NoteMapController.swift
//  LocationNotes
//
//  Created by Евгений on 27/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import MapKit

class NoteAnnotation: NSObject, MKAnnotation {
    
    var note: Note
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(note: Note) {
        self.note = note
        coordinate = CLLocationCoordinate2D(latitude: note.locationActual!.latitude, longitude: note.locationActual!.longitude)
        title = note.name
    }
    
}

class NoteMapController: UIViewController {

    var note: Note?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if note?.locationActual != nil {
            mapView.addAnnotation(NoteAnnotation(note: note!))
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: note!.locationActual!.latitude, longitude: note!.locationActual!.longitude)
        }
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [lpgr]
        
    }
    
    @objc func handleLongTap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        let point = recognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        note?.locationActual = LocationCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CoreDataManager.sharedInstance.saveContext()
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(NoteAnnotation(note: note!))
    }

}

extension NoteMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            let newCoordinate = LocationCoordinate(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.latitude)!)
            note?.locationActual = newCoordinate
        }
    }
    
}
