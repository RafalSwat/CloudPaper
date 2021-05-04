//
//  HomeViewController.swift
//  CloudPaper
//
//  Created by Rafał Swat on 26/04/2021.
//

import UIKit

class HomeViewController: KeyboardHandlingBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet var addNoteView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var warrningMessage: UILabel!
    
    var tap             : UITapGestureRecognizer!
    let fireBaseManager = FireBaseManager()
    var notes           = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLogoutItem()
        setuptableViewDelegates()
        setupNotes()
    }
    @IBAction func addNoteButtonPressed(_ sender: Any) {
        
        self.animateIn()
    }
    @objc func logOutButtonPressed() {
        tryLogout()
    }
    @IBAction func saveNoteButtonPressed(_ sender: Any) {
        if let note = createNote() {
            self.saveNote(note: note)
            self.restoreDefaultForView()
            self.animateOut()
        } else {
            self.setupWarningMessage(message: "Can't save a empty note!")
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.animateOut()
    }
    
    func setupLogoutItem() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logOutButtonPressed))
    }
    func setuptableViewDelegates() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    func tryLogout() {
        self.fireBaseManager.logout() { (successfullyLogout, errorDescriptyion) in
            if successfullyLogout {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                //error handling
            }
        }
    }
    func animateIn() {
        self.view.backgroundColor = .darkGray
        self.view.addSubview(addNoteView)
        addNoteView.center = self.view.center
        addNoteView.layer.cornerRadius = 10
        addNoteView.layer.borderColor = UIColor.lightGray.cgColor
        addNoteView.layer.borderWidth = 1
        addNoteView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addNoteView.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {
            self.addNoteView.alpha = 1
            self.addNoteView.transform = CGAffineTransform.identity
        })
    }
    @objc func animateOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.addNoteView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addNoteView.alpha = 0
            self.view.backgroundColor = .systemBackground

        }) { (success:Bool) in
            self.addNoteView.removeFromSuperview()
        }
    }
    func saveNote(note: Note) {
        self.fireBaseManager.addNote(note: note) { saveSuccess, errorDescription in
            if saveSuccess {
                self.notes.append(note)
                self.tableView.reloadData()
            } else {
                self.setupWarningMessage(message: errorDescription ?? "Error: Can't save the note!")
            }
        }
    }
    func createNote() -> Note? {
        if noteTextField.text != "" && noteTextField.text != nil {
            let noteText = noteTextField.text!
            let noteDate = DateConverter.dateFormat.string(from: datePicker.date)
            let noteDone = false
            
            let note = Note(text: noteText,
                            date: noteDate,
                            done: noteDone)
            return note
        } else {
            return nil
        }
    }
    func restoreDefaultForView() {
        self.noteTextField.text = ""
        self.datePicker.date = Date()
    }
    func setupWarningMessage(message: String) {
        DispatchQueue.main.async {
            self.warrningMessage.text = message
        }
    }
    func setupNotes() {
        self.fireBaseManager.dwonloadNotes(completion: { data, downloadSuccessful, message in
            if downloadSuccessful {
                self.notes = data
                self.tableView.reloadData()
            } else {
                self.notes = data
                print(message ?? "Error during downlading data!")
            }
        })
    }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NoteViewCell
        cell.setupNoteCell(note: note, index: indexPath.row)
        cell.cellDelegate = self
        return cell
    }
    
    func estimateRowHeight() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
}
extension HomeViewController: NoteCellDelegate {
    func updateDoneProperty(at index: Int) {
        if self.notes[index].done == true {
            self.notes[index].done = false
        } else {
            self.notes[index].done = true
        }
        self.fireBaseManager.updateNote(note: notes[index])
    }
    
    
}
