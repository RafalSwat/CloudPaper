//
//  NoteViewCell.swift
//  CloudPaper
//
//  Created by Rafał Swat on 28/04/2021.
//

import UIKit

protocol NoteCellDelegate {
    func updateDoneProperty(at index: Int)
}

class NoteViewCell: UITableViewCell {

    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var doneImage: UIImageView!
    var index = 0
    var cellDelegate: NoteCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // You must to use interaction enabled
        doneImage.isUserInteractionEnabled = true
        doneImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }
    
    func setupNoteCell(note: Note, index: Int) {
        noteText?.text = note.text
        date.text = note.date
        if note.done == true {
            doneImage.image = UIImage(systemName: "checkmark")
        } else {
            doneImage.image = UIImage(systemName: "exclamationmark")
        }
        self.index = index
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        if doneImage.image == UIImage(systemName: "checkmark") {
            doneImage.image = UIImage(systemName: "exclamationmark")
        } else {
            doneImage.image = UIImage(systemName: "checkmark")
        }
        cellDelegate.updateDoneProperty(at: index)
    }
}
