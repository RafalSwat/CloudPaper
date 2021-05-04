//
//  FireBaseManager.swift
//  CloudPaper
//
//  Created by Rafał Swat on 26/04/2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FireBaseManager {
    
    let userDBRef = Database.database(url: "https://cloudpaper-608ec-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    func createUser(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false, error?.localizedDescription)
            } else {
                if let authResult = result {
                    self.userDBRef.child("Users").child(authResult.user.uid).setValue(authResult.user.email) { error, ref in
                        if error != nil {
                            completion(false, error?.localizedDescription)
                        }
                    }
                }
                completion(true, nil)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, String?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                completion(false, error?.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func logout(completion: @escaping (Bool, String?)->()) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let error {
            completion(false, "Error: can`t Log Out: \(error.localizedDescription)")
        }
    }
    
    func autoLogin(completion: @escaping (Bool)->()) {
        if Auth.auth().currentUser != nil {
           completion(true)
        } else {
            completion(false)
        }
    }
    
    func addNote(note: Note, completion: @escaping (Bool, String?)->()) {
        if let user  = Auth.auth().currentUser {
            self.userDBRef.child("Notes").child(user.uid).child(note.id).setValue(
                ["note" : note.text,
                 "date" : note.date,
                 "done" : note.done]
            ) { error, ref in
                if error != nil {
                    completion(false, error?.localizedDescription ?? "Error: Can't save the note!")
                } else {
                    completion(true, nil)
                }
            }
        } else {
            completion(false, "Error: I cannot find the logged in user!")
        }
    }
    
    func removeNote(note: Note, completion: @escaping (Bool, String?)->()) {
        if let user  = Auth.auth().currentUser {
            self.userDBRef.child("Notes").child(user.uid).child(note.id).removeValue() { error, ref in
                if error != nil {
                    completion(false, error?.localizedDescription ?? "Error: Can't delete the note!")
                } else {
                    completion(true, nil)
                }
            }
        } else {
            completion(false, "Error: I cannot find the logged in user!")
        }
    }
    
    func dwonloadNotes(completion: @escaping ([Note], Bool, String?)->()) {
        var notes = [Note]()
        
        if let user  = Auth.auth().currentUser {
            self.userDBRef.child("Notes").child(user.uid).observeSingleEvent(of: .value) { (userSnapshot) in
                
                var counter = 0
                let objectCount = userSnapshot.childrenCount
                
                if let userNotes = userSnapshot.children.allObjects as? [DataSnapshot]  {
                    for snap in userNotes  {
                        if let snapValues = snap.value as? [String : Any] {
                            
                            let id   = snap.key
                            let txt  = snapValues["note"] as! String
                            let date = snapValues["date"] as! String
                            let done = snapValues["done"] as! Bool
                            
                            let note = Note(id: id,
                                            text: txt,
                                            date: date,
                                            done: done)
                            notes.append(note)
                            counter += 1
                            
                            if counter == objectCount {
                                completion(notes, true, nil)
                            }
                        } else {
                            completion(notes, false, "Error: can't find/convert data from Database!")
                        }
                    }
                } else {
                    completion(notes, false, "Error: can't find/convert data from Database!")
                }
            }
        } else {
            completion(notes, false, "Error: I cannot find the logged in user!")
        }
    }
    func updateNote(note: Note) {
        if let user  = Auth.auth().currentUser {
            self.userDBRef.child("Notes").child(user.uid).child(note.id).updateChildValues(
                ["note" : note.text,
                 "date" : note.date,
                 "done" : note.done])
        }
    }
}
