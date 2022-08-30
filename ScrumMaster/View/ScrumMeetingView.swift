//
//  ScrumMeetingView.swift
//  ScrumMaster
//
//  Created by Consultant on 8/23/22.
//

import SwiftUI

struct ScrumMeetingView: View {
    let addAllPosts: (RecentPost)-> ()
    @Environment (\.presentationMode) var presentationMode
    @ObservedObject var smvm = ScrumMeetingViewModel()
    @ObservedObject var mpvm = MainPostsViewModel()

    
    var body: some View {
        NavigationView {
            ScrollView{
                ForEach(smvm.messages) { post in
                    VStack(alignment: .leading, spacing: 2){
                        Text(post.text)
                    }.background(Color(.lightGray))
                                                    .padding()
                }
//                ScrumLoadingView
            }.navigationTitle("Scrum Posts +")
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
                            smvm.createPdf()
                        } label: {
                            Image(systemName: "doc")
                            Text("PDF")
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
struct ScrumMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
    }
}
