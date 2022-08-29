//
//  FirebaseManager.swift
//  ScrumMaster
//
//  Created by Consultant on 8/14/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ScrumUser?
    
    static let shared = FirebaseManager()
       override init(){
            FirebaseApp.configure()
           self.auth = Auth.auth()
           self.storage = Storage.storage()
           self.firestore = Firestore.firestore()
           super.init()
        }
}

