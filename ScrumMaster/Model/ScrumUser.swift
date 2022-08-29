//
//  ScrumUser.swift
//  ScrumMaster
//
//  Created by Consultant on 8/16/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ScrumUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let email: String
    let firstname: String
    let lastname: String
    let company: String
    let profileImageUrl: String
}
