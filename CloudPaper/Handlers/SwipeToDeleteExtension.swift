//
//  SwipeToDeleteExtension.swift
//  CloudPaper
//
//  Created by Rafał Swat on 27/04/2021.
//

import Foundation
import UIKit

extension HomeViewController {
    
    // Add swipe configuration
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // Implemented the delete functionalty
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let note = notes[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") {
            (action, view, completion) in

            self.fireBaseManager.removeNote(note: note) { removeSuccessful, errorDescription in
                if removeSuccessful {
                    self.notes.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    completion(true)
                } else {
                    print("\(errorDescription ?? "Error during delete action!")")
                }
            }
        }

        action.backgroundColor = .red
        return action
    }
}
