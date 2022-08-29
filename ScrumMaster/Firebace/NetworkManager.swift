//
//  ScrumPostView.swift
//  ScrumMaster
//
//  Created by Consultant on 8/17/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestoreSwift


class ScrumLogViewModel: ObservableObject {
    @Published var scrumText = ""
    @Published var errorMessage = ""
    @Published var scrumPosts = [ScrumPost]()
    
    var scrumUser: ScrumUser?
    init(scrumUser: ScrumUser?) {
        self.scrumUser = scrumUser
        fetchPosts()
    }
    var firestoreListener: ListenerRegistration?
    
    func fetchPosts() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = scrumUser?.uid else {return}
        firestoreListener?.remove()
        scrumPosts.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.posts)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for post: \(error)"
                    print(error)
                    return
                }
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let cm = try? change.document.data(as: ScrumPost.self) {
                                self.scrumPosts.append(cm)
                                print("Appending scrumposts in ScrumLOgView: \(Date())")
                            }
                        } 
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                }
                
            }
    }
    func handleStoreToDB(){
 guard let kat = FirebaseManager.shared.auth.currentUser?.uid else {return}
 let document = FirebaseManager.shared.firestore.collection("\(FirebaseManager.shared.currentUser?.company ?? "Me")")
                            .document(kat)
        let msg = ScrumMessage (id: nil, company: ("\(FirebaseManager.shared.currentUser?.company ?? "Company")"), text: ("\(FirebaseManager.shared.currentUser?.firstname ?? "") \(FirebaseManager.shared.currentUser?.lastname ?? "")\n\(FirebaseManager.shared.currentUser?.company ?? "Me")\n") + scrumText, timestamp: Date())
        try? document.setData(from: msg) {error in
            if let error = error {
                self.errorMessage = "Failed to save post: \(error)"
                return
            }
            print("Succesifuly saved post ")

            self.persistRecentPost()
            self.scrumText = ""
            self.count += 1
        }
// document.setData(["Text": scrumText, "Timestamp": Date()])
    }

    func handleSend(){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = scrumUser?.uid else {return}
        let document =
        FirebaseManager.shared.firestore.collection(FirebaseConstants.posts)
            .document(fromId)
            .collection(toId)
            .document()

        let pst = ScrumPost ( id: nil, fromId: fromId, toId: toId, text: ("\(FirebaseManager.shared.currentUser?.firstname ?? "") \(FirebaseManager.shared.currentUser?.lastname ?? "")\n\(FirebaseManager.shared.currentUser?.company ?? "Me")\n") + scrumText, timestamp: Date())
        try? document.setData(from: pst) {error in
            if let error = error {
                self.errorMessage = "Failed to save post: \(error)"
                return
            }
            print("Succesifuly saved post ")

            self.persistRecentPost()
            self.scrumText = ""
            self.count += 1
        }
        let recipientPostDocument = FirebaseManager.shared.firestore.collection("posts") /// Check That code before fetching! ///
            .document(toId)
            .collection(fromId)
            .document()

        try? recipientPostDocument.setData(from: pst) {error in
            if let error = error {
                self.errorMessage = "Failed to save post: \(error)"
                return
            }
            print("Recipient saved message as well")
        }
    }
    

    

    private func persistRecentPost() {
        guard let scrumUser = scrumUser else {return}
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = self.scrumUser?.uid else {return}
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentPosts)
            .document(uid)
            .collection(FirebaseConstants.posts)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.scrumText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: scrumUser.profileImageUrl,
            FirebaseConstants.email: scrumUser.email
        ] as [String: Any]
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message:\(error)"
                print("Failed to save recent message:\(error)")
                return
            }
        }
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.scrumText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
            FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentPosts)
            .document(toId)
            .collection(FirebaseConstants.posts)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    @Published var count = 0
}

struct ScrumLogView: View {
    
    @ObservedObject private var msvm = MainPostsViewModel()
    @ObservedObject var slvm: ScrumLogViewModel
    var body: some View {
        
        VStack {
            ScrollView {
                postsView
                HStack { Spacer() }
            }.navigationTitle(slvm.scrumUser?.company ?? "Navigation title check")
                .navigationBarTitleDisplayMode(.inline)
                .onDisappear {
                    slvm.firestoreListener?.remove()
                }
            scrumBottomBar
        }        
    }
    
    static let emptyScrollToString = ""
    private var postsView: some View {
        VStack{
            if #available(iOS 15.0, *){
                ScrollView{
                    ScrollViewReader {ScrollViewProxy in
                        VStack{
                            ForEach(slvm.scrumPosts){ post in
                                PostView(post: post)
                            }
                            .id(Self.emptyScrollToString)
                        }                        .onReceive(slvm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                ScrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
    private var scrumBottomBar: some View {
        HStack(spacing: 16){
            VStack(alignment: .leading){
                HStack{
                    Button{
                        
                        
                    } label: {
                        Image(systemName: "doc")
                            .font(.system(size: 29))
                            .foregroundColor(Color(.darkGray))
                    }

                    let lastname = msvm.scrumUser?.lastname ?? "Me"
                    let firstnamE = (msvm.scrumUser?.firstname ?? "I's") + " " + lastname
                    VStack(alignment: .leading, spacing: 2){
                        Text(firstnamE)
                            .font(.system(size: 18, weight: .semibold))
                        Text(msvm.scrumUser?.company ?? "Company")
                            .font(.system(size: 12, weight: .light))
                    }
                    Spacer()
                    Button {
                        slvm.handleSend()
                        slvm.handleStoreToDB()
                    } label: {
                        Text("POST")
                            .foregroundColor(.white)
                    }.padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.init(gray: 0.4, alpha: 1)))
                        .cornerRadius(6)
                    
                }.padding(4)
                DescriptionPlaceholder()
                TextEditor(text: $slvm.scrumText)
                    .font(.system(.body))
                    .frame(height: max(160, 1))
                
                    .cornerRadius(10.0)
                    .shadow(radius: 1.0)
                    .foregroundColor(Color(.init(gray: 0.1, alpha: 1)))
            }
        }.padding(.horizontal)
            .padding(.vertical, 0)
    }
}
struct PostView: View {
    let post: ScrumPost
    var body: some View {
        HStack {
            if post.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack{
                    VStack(alignment: .leading, spacing: 2){
                        Text (post.text)
                    }.padding()
                }
                .padding()
                .background(Color(.init(white: 0.9, alpha: 4)))
                
            } else {
                HStack{
                    VStack(alignment: .leading, spacing: 2){
                        Text (post.text)
                        Spacer()
                    }
                    .padding()
                    .background(Color(.init(white: 0.9, alpha: 4)))
                }
            }
        }.padding(.top, 1)
    }
}
private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("PDF")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
struct ScrumlogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainPostsView()
        }
    }
}
