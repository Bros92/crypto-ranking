//
//  NavigationTitleViewModifier.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import SwiftUI

/// A modifier to use the update api of NavigationVIew
struct NavigationTitleViewModifier: ViewModifier {
    /// The title of navigation view
    var text: String
    /// The mode to display the title
    var displayMode: NavigationBarItem.TitleDisplayMode
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(text)
            .navigationBarTitleDisplayMode(displayMode)
    }
}
