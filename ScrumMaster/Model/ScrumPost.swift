//
//  ScrumPost.swift
//  ScrumMaster
//
//  Created by Consultant on 8/20/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ScrumPost: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}
