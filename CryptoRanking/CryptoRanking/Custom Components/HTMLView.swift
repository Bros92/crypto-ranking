//
//  HTMLView.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import Foundation
import SwiftUI

struct HTMLTextView: UIViewRepresentable {
    
    var attributedString: NSAttributedString
    @Binding var calculatedHeight: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        let textView = UITextView()
        textView.attributedText = attributedString
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.dataDetectorTypes = .link
        textView.delegate = context.coordinator
        textView.tintColor = .orange
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        DispatchQueue.main.async {
            calculatedHeight = textView.heightToFitContent()
        }
        return textView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> HTMLTextViwCoordinator {
        return HTMLTextViwCoordinator()
    }
    
    class HTMLTextViwCoordinator: NSObject, UITextViewDelegate {
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            var urlString = URL.absoluteString
            // Add http to open the url if needed
            if !urlString.starts(with: "http") {
                urlString = "https://" + urlString
            }
            guard let url = urlString.url, UIApplication.shared.canOpenURL(url) else {
                return false
            }
            // Open the url on tap
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
    }
}
