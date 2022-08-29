//
//  RecentPost.swift
//  ScrumMaster
//
//  Created by Consultant on 8/20/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

struct RecentPost: Codable, Identifiable {
    @DocumentID var id: String?
    let documentId: String
    let firstname: String
    let lastname: String
    let company: String
    let text, email: String
    let fromId, toId: String
    let imageProfileUrl: String
    let timestamp: Date
}


