//
//  CornerRadiusStyle.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 15/10/22.
//

import SwiftUI

/// The modifier to apply to get a view with corner radius
struct CornerRadiusStyle: ViewModifier {
    /// The radius of corner
    var radius: CGFloat
    /// The corners to round
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        
        func path(in rect: CGRect) -> Path {
            // Round corners layer with UIBezierPath
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
        // Set view modifier as clipping shape
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

