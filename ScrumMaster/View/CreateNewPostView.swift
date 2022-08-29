//
//  NewGroup.swift
//  ScrumMaster
//
//  Created by Consultant on 8/16/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage


struct CreateNewPostView: View {
    let didSelectNewUser: (ScrumUser) -> ()
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var cnmvm = CreateNewGroupViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(cnmvm.errorMessage)
                ForEach (cnmvm.users) { user in
                        HStack (spacing: 8) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipped()
                                .cornerRadius(49)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(.label), lineWidth: 1)
                                )
                            VStack(spacing: 16) {
                                HStack{
                                    Text (user.firstname)
                                    Text (user.lastname)
                                }.frame(width: 200, height: 8, alignment: .leading)
                                Text(user.email)
                                    .frame(width: 100, height: 8, alignment: .leading)
                                    .foregroundColor(Color(.gray))
                            }
                            Spacer()
                            Button {//==============================================
                                presentationMode.wrappedValue.dismiss()
                                didSelectNewUser(user)
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .padding()
                                    .foregroundColor(Color(.red))
                            }
//                            Text(user.email)
                        }.padding(.horizontal)
                        Divider()
                            .padding(.vertical, 8)
                }
            }.navigationTitle("")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        HStack{
                            VStack {
                                Button {
                                    presentationMode.wrappedValue
                                        .dismiss()
                                } label: {
                                    Text("cancel")
                                        .foregroundColor(Color(.red))
                                }
                            }
                            
                            Spacer()
                            VStack (alignment: .trailing) {
                                Button {
                                    presentationMode.wrappedValue
                                        .dismiss()
                                } label: {
                                    Text("add")
                                        .frame(width: 100, height: 8, alignment: .leading)
                                        .foregroundColor(Color(.red))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }

                    }
                }
        }
    }
}

struct CreateNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
}
}
