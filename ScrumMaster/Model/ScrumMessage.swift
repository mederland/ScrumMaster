//
//  ScrumMessage.swift
//  ScrumMaster
//
//  Created by Consultant on 8/25/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

struct ScrumMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let company: String
    let text: String
    let timestamp: Date
    var normalDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: timestamp) // 12/15/16
    }
}
