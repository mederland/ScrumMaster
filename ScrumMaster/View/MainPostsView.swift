//
//  MainScrum.swift
//  ScrumMaster
//
//  Created by Consultant on 8/15/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI


struct MainPostsView: View {
    @State var shouldShowLogOutOptions = false
    @State var shouldNavigateToGroupLogView = false
    @State var scrumDate = Date()
    @ObservedObject private var mpvm = MainPostsViewModel()
    private var scrumLogViewModel = ScrumLogViewModel(scrumUser: nil)
//    private var mainPostsViewModel = MainPostsViewModel(recentPost: nil)
    
    
    
    var body: some View {
        NavigationView {
            VStack{
                customNavBar
                calendarDatePickerView
                CompanyScrumButton
                postsView
                NavigationLink("", isActive: $shouldNavigateToGroupLogView) {
                    ScrumLogView(slvm: scrumLogViewModel)
                }
            }
            .overlay(
                newPostButton, alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing:8){
            WebImage(url: URL(string: mpvm.scrumUser?.profileImageUrl ?? ""))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(50)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                        .stroke(Color(.label), lineWidth: 1)
                            )
                            .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 2){
                let lastname = mpvm.scrumUser?.lastname ?? "Me"
                let firstname = (mpvm.scrumUser?.firstname ?? "I's") + " " + lastname
                        Text(firstname)
                    .font(.system(size: 24, weight: .bold))
                HStack{
                    let company = mpvm.scrumUser?.company ?? "Company"
                            Text(company)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image (systemName: "gear")
                    .font(.system(size: 24,weight: .light))
                    .foregroundColor(Color(.label))
            }


        }.padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Log Out"), message: Text("Is Scrum meeting finished?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        
                            mpvm.handleSignOut()
                        }),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $mpvm.isUserCurrentlyLoggedOut,
            onDismiss: nil) {
                LoginView(didCompleteLoginProcess: {
                    self.mpvm.isUserCurrentlyLoggedOut = false
                    self.mpvm.fetchCurrentUser()
                    self.mpvm.fetchRecentPosts()
                })
            }
    }
    private var postsView: some View {
        ScrollView {
            ForEach(mpvm.recentPosts) { recentPost in
                VStack{
                    Button {
                        self.scrumLogViewModel.fetchPosts()
                        self.shouldNavigateToGroupLogView.toggle()
                    } label: {
                        HStack(spacing: 8){
                            VStack(alignment: .leading){
                                Text(recentPost.text)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Text(recentPost.timestamp.description)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }

                    Divider()
                        .padding(.vertical,8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
     var calendarDatePickerView: some View {
        Form {
            DatePicker("Scrum Date", selection: $scrumDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
        }
    }
    
    @State var shouldShowPostingScreen = false
     var CompanyGroupPostButton: some View {

        Button {
            shouldShowPostingScreen.toggle()
        } label: {
            HStack{
                Spacer(minLength: 16)
                Text("Company")
                .font(.system(size: 16, weight: .bold))
                Spacer(minLength: 16)
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color(.lightGray))
            .cornerRadius(8)
            .padding(.horizontal)
            .shadow(radius: 5)
        }
        .fullScreenCover(isPresented: $shouldShowPostingScreen) {
            ScrumMeetingView (addAllPosts: { posts in
                print(posts)
                self.shouldNavigateToGroupLogView.toggle()
            })
        }

    }
    @State var shouldShowNewPostScreen = false
    private var CompanyScrumButton: some View {

        Button {
            shouldShowNewPostScreen.toggle()
        } label: {
            HStack{
                Spacer(minLength: 16)
                Text("PDF for Windows users")
                .font(.system(size: 16, weight: .bold))
                Spacer(minLength: 16)
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color(.lightGray))
            .cornerRadius(8)
            .padding(.horizontal)
            .shadow(radius: 5)
        }
        .fullScreenCover(isPresented: $shouldShowNewPostScreen) {
            ScrumMeetingView (addAllPosts: { posts in
                print(posts)
                self.shouldNavigateToGroupLogView.toggle()
            })
        }

    }
    @State var scrumPost: ScrumPost?
    
    @State var shouldShowScrumMasterScreen = false
    
    private var newPostButton: some View {
            Button {
                shouldShowScrumMasterScreen.toggle()
            } label: {
        HStack{
        Spacer()
        Text("+ Find Scrum Master")
            .font(.system(size: 16, weight: .bold))
        Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical)
        .background(Color.red)
        .cornerRadius(32)
        .padding(.horizontal)
        .shadow(radius: 5)
        }
            .fullScreenCover(isPresented: $shouldShowScrumMasterScreen) {
                CreateNewPostView (didSelectNewUser: { user in
                    print(user.email)
                    self.shouldNavigateToGroupLogView.toggle()
                    self.scrumUser = user
                    self.scrumLogViewModel.scrumUser = user
                    self.scrumLogViewModel.fetchPosts()
                })
            }
    }
    
    @State var scrumUser: ScrumUser?
}


struct MainScrumView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
    }
}
