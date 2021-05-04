//
//  Utilities.swift
//  CloudPaper
//
//  Created by Rafał Swat on 26/04/2021.
//

import Foundation

class Utilities {
    static func checkPassword(password: String) -> Bool {
        let testPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return testPassword.evaluate(with: password)
    }
}
