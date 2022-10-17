//
//  RoundedEdge.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import SwiftUI

/// The modifier to get rounded corner of layer with border color
struct RoundedEdge: ViewModifier {
    /// The width of border
    let width: CGFloat
    /// The border color
    let color: Color
    /// The radii of corner
    let cornerRadius: CGFloat
    /// The corners of rectangle
    let edges: UIRectCorner

    func body(content: Content) -> some View {
        // Round corner of internal content
        content.cornerRadius(radius: cornerRadius - width, corners: edges)
        //  Add border
            .padding(width)
        // Set the color of border
            .background(color)
        // Apply rounded corner to external content
            .cornerRadius(radius: cornerRadius, corners: edges)
    }
}
