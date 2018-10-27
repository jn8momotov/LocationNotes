//
//  MapController.swift
//  LocationNotes
//
//  Created by Евгений on 27/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressedOnMap))
        mapView.gestureRecognizers = [longPress]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        for note in notes {
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
            }
        }
    }
    
    @objc func longPressedOnMap(recognizer: UIGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        let point = recognizer.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let newNote = Note.newNote(name: "", in: nil)
        newNote.locationActual = LocationCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
        showController(with: newNote)
    }
    
    func showController(with note: Note) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "noteId") as! NoteController
        controller.note = note
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            DispatchQueue.main.async {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        showController(with: (view.annotation as! NoteAnnotation).note)
    }
    
}
