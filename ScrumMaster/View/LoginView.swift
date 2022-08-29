//
//  ContentView.swift
//  ScrumMaster
//
//  Created by Consultant on 8/11/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var isLoginMode = false
    @State var firstname = ""
    @State var lastname = ""
    @State var company = ""
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var loginStatusMessage = ""
    @State var image: UIImage?
    
    
    
    let didCompleteLoginProcess: () -> ()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 24, height: 24)
                                        .cornerRadius(24)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 14))
                                        .padding()
                                        .foregroundColor(Color(.red))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.red, lineWidth: 1))
                        }
                        
                        Group {
                            TextField("Name", text: $firstname)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            TextField("Last Name", text: $lastname)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            TextField("Company", text: $company)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        .padding(12)
                    }
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.red)
                    }
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "ScrumMaster" : "ScrumMaster")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
            print("A new account inside of Firebase registered")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
            self.didCompleteLoginProcess()
        }
    }
    
    private func createNewAccount() {
        if self.image == nil {
            self.loginStatusMessage = "You must select avatar image"
            return
        }
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password ) { result, err in
            if let err = err {
                print("User Creation Failed", err)
                self.loginStatusMessage = "User Creation Failed: \(err)"
                return
            }
            print("Successfuly created  user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfuly created  user: \(result?.user.uid ?? "")"
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid =
                FirebaseManager.shared.auth.currentUser?.uid else {return}
        let userData = ["email": self.email, "uid": uid, "firstname": self.firstname, "lastname": self.lastname, "company": self.company, "profileImageUrl": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
                
                self.didCompleteLoginProcess()
            }
    }
    //--------------------------------------------------
     func storeCompanyGroup(imageProfileUrl: URL) {
         guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
         let groupCompanyData = ["email": self.email, "uid": uid, "firstname": self.firstname, "lastname": self.lastname, "company": self.company, "profileImageUrl": imageProfileUrl.absoluteString]
         FirebaseManager.shared.firestore.collection(self.company)
             .document(FirebaseConstants.messages)
             .setData(groupCompanyData)
    }
    
}
struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView(didCompleteLoginProcess: {
            
        })
        .preferredColorScheme(.dark)
        
    }
}

