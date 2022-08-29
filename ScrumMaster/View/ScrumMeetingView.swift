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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    TUT TAKAYA HUINYA
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
//    var ScrumLoadingView: some View {
//        NavigationView{
//            ScrollView{
//                HStack{
//                    VStack(alignment: .leading, spacing: 2){
//                        VStack(alignment: .leading, spacing: 2){
//                            Text ("Christopher Columb")
//                            Text ("EnhanceIT")
//                            Text ("-Practiced on his interview and working in his final project")
//                            Text ("-Working on her final project, research on internet")
//                            Text ( "-Working final project")
//                            Text ( "-Working on his final project, practice in his interview")
//                        }.background(Color(.lightGray))
//                            .padding()
//                        Spacer()
//                        VStack(alignment: .leading, spacing: 2){
//                            Text ( "Rual Amundsen")
//                            Text ("EnhanceIT")
//                            Text ("-Working on his final project and watching videos")
//                            Text ("-Working on her final project")
//                            Text ( "-Working  on his final project and Fixing bugs")
//                            Text ("-Worked on his project and prepared his interview")
//                        }.background(Color(.lightGray))
//                            .padding()
//                        Spacer()
//                        VStack(alignment: .leading, spacing: 2){
//                            Text ("Jack London")
//                            Text ("EnhanceIT")
//                            Text ("-Practiced on his interview and working in his final project")
//                            Text ("-Working on her final project, research on internet")
//                            Text ("-Working final project")
//                            Text ("-Working on his final project, practice in his interview")
//                        }.background(Color(.lightGray))
//                            .padding()
//                        Spacer()
//                        VStack(alignment: .leading, spacing: 2){
//                            Text ("Francis Drake")
//                            Text ("EnhanceIT")
//                            Text ("-Working on his final project and watching videos")
//                            Text ("-Working on her final project")
//                            Text ("-Working  on his final project and Fixing bugs")
//                            Text ("-Worked on his project and prepared his interview")
//                        }.background(Color(.lightGray))
//                            .padding()
//                        Spacer()
//                        VStack(alignment: .leading, spacing: 2){
//                            Text ("Fernan Magelan")
//                            Text ("EnhanceIT")
//                            Text ("-Practiced on his interview and working in his final project")
//                            Text ("-Working on her final project, research on internet")
//                            Text ("-Working final project")
//                            Text ("-Working on his final project, practice in his interview")
//                        }.background(Color(.lightGray))
//                            .padding()
//                }
//
//                }
//
//            }
//        }
//
//   }
    
    
    
    
}
struct ScrumMeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MainPostsView()
    }
}
