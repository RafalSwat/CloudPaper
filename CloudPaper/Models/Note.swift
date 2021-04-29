//
//  Note.swift
//  CloudPaper
//
//  Created by Rafał Swat on 26/04/2021.
//

import Foundation

class Note {
    var id   : String
    var text : String
    var date : String
    var done : Bool
    
    init(text: String, date: String, done: Bool) {
        self.id   = UUID().uuidString
        self.text = text
        self.date = date
        self.done = done
    }
    init(id: String, text: String, date: String, done: Bool) {
        self.id   = id
        self.text = text
        self.date = date
        self.done = done
    }
}
