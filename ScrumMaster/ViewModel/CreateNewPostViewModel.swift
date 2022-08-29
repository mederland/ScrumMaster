//
//  CreateNewGroupViewModel.swift
//  ScrumMaster
//
//  Created by Consultant on 8/21/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

class CreateNewGroupViewModel: ObservableObject {
    @Published var users = [ScrumUser]()
    @Published var errorMessage = ""
    init() {
        fetchAllUsers()
    }
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fethc users: \(error)"
                    print("Failed to fethc users: \(error)")
                    return
                }
                documentSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ScrumUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
                })
            }
    }
}
