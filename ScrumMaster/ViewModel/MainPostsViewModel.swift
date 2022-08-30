//
//  MainScrumViewModel.swift
//  ScrumMaster
//
//  Created by Consultant on 8/16/22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import SDWebImage


class MainPostsViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var scrumUser: ScrumUser?
    @Published var isUserCurrentlyLoggedOut = false
   
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
        fetchRecentPosts()
    }
    
    @Published var recentPosts = [RecentPost]()
    private var firestoreListener: ListenerRegistration?
    
 func fetchRecentPosts() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
     firestoreListener?.remove()
     self.recentPosts.removeAll()
     
     firestoreListener = FirebaseManager.shared.firestore
         .collection(FirebaseConstants.recentPosts)
            .document(uid)
            .collection(FirebaseConstants.posts)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Fail recent post: \(error)"
                    print(error)
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                        let docId = change.document.documentID
                    print(self.recentPosts)
                    if let index =
                        self.recentPosts.firstIndex(where: { rm in
                            return rm.id == docId
                        }){
                        self.recentPosts.remove(at: index)
                        }
                    do {
                       if let rm = try? change.document.data(as: RecentPost.self) {
                           print(self.recentPosts)
                        self.recentPosts.insert(rm, at: 0)
                           print("Nakonec: \(Date())")
                           print(self.recentPosts)
                       }
                    }
                })
                }
    }
    
    func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            self.scrumUser = try? snapshot?.data(as: ScrumUser.self)
                FirebaseManager.shared.currentUser = self.scrumUser
            }
    }
    
    func handleSignOut(){
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
}
