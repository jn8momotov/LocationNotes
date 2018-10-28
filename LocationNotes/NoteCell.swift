//
//  NoteCell.swift
//  LocationNotes
//
//  Created by Евгений on 28/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var imageNoteView: UIImageView!
    @IBOutlet weak var nameNoteLabel: UILabel!
    @IBOutlet weak var dateUpdateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func initCell(for note: Note) {
        nameNoteLabel.text = note.name
        dateUpdateLabel.text = note.dateUpdateString
        imageNoteView.layer.cornerRadius = imageNoteView.frame.width / 2
        imageNoteView.clipsToBounds = true
        if let _ = note.location {
            locationLabel.text = "Location".localize()
        }
        else {
            locationLabel.text = ""
        }
        if let nsDate = note.imageSmall {
            imageNoteView.image = UIImage(data: nsDate as Data)
        }
        else {
            imageNoteView.image = UIImage(named: "defaultImageNote")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
