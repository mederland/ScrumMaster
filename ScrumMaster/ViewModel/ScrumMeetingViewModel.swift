//
//  ScrumMeetingViewModel.swift
//  ScrumMaster
//
//  Created by Consultant on 8/23/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import PDFKit

class ScrumMeetingViewModel: ObservableObject {
    @Published var messages = [ScrumMessage]()
    @Published var errorMessage = ""
    @Published var scrumDate = Date()
    var count = 0
    init() {
        fetchPDFMessages()
        createPdf()
    }
    
func fetchPDFMessages() {
            FirebaseManager.shared.firestore.collection("\(FirebaseManager.shared.currentUser?.company ?? "Company")")
                .getDocuments { documentSnapshot, error in
                    if let error = error {
                        self.errorMessage = "Failed to fethc message: \(error)"
                        return
                    }
                    documentSnapshot?.documents.forEach({ snapshot in
                        let msg = try? snapshot.data(as: ScrumMessage.self)
                        self.messages.append(msg!)
//                        if msg?.timestamp == Date() {
//                          
//                        }
                    })
                DispatchQueue.main.async {
                    self.count += 1
                }
}
}
    func createPdf() {

        let outputFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Date()) ScrumMaster.pdf")
            let title = "\(Date()) Scrum Meeting\n"
            let text = String(repeating: "Your string row from List View or ScrollView \n ", count: 2000)

            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)]
            let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]

            let formattedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
            let formattedText = NSAttributedString(string: text, attributes: textAttributes)
            formattedTitle.append(formattedText)

            // 1. Create Print Formatter with your text.

            let formatter = UISimpleTextPrintFormatter(attributedText: formattedTitle)

            // 2. Add formatter with pageRender

            let render = UIPrintPageRenderer()
            render.addPrintFormatter(formatter, startingAtPageAt: 0)

            // 3. Assign paperRect and printableRect

            let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
            let printable = page.insetBy(dx: 0, dy: 0)

            render.setValue(NSValue(cgRect: page), forKey: "paperRect")
            render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

            // 4. Create PDF context and draw
            let rect = CGRect.zero

            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, rect, nil)

            for i in 1...render.numberOfPages {

                UIGraphicsBeginPDFPage();
                let bounds = UIGraphicsGetPDFContextBounds()
                render.drawPage(at: i - 1, in: bounds)
            }

            UIGraphicsEndPDFContext();

            // 5. Save PDF file

            do {
                try pdfData.write(to: outputFileURL, options: .atomic)

                print("wrote PDF file with multiple pages to: \(outputFileURL.path)")
            } catch {

                 print("Could not create PDF file: \(error.localizedDescription)")
            }
        }
}

