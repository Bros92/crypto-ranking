//
//  ShimmerView.swift
//  CryptoRanking
//
//  Created by Vincenzo Broscritto on 16/10/22.
//

import SwiftUI
import Combine

/// The configuration for the shimmer
class ShimmerConfig: ObservableObject {
    
    let willChange = PassthroughSubject<ShimmerConfig, Never>()
    
    var bgColor: Color
    var fgColor: Color
    var shimmerColor: Color
    var shimmerAngle: Double
    var shimmerDuration: Double
    
    /// The timer for animation duration
    private var timer: AnyCancellable?
    /// The timer to fire the shimmer event immediately
    private var fireTimer: AnyCancellable?
    
    @Published var isActive: Bool = false
    
    init(bgColor: Color = .shimmerBackgroundColor,
         fgColor: Color = .white,
         shimmerColor: Color = Color.lightGrey.opacity(0.8),
         shimmerAngle: Double = 0,
         shimmerDuration: TimeInterval = 2,
         shimmerDelay: TimeInterval = 2.1) {
        self.bgColor = bgColor
        self.fgColor = fgColor
        self.shimmerColor = shimmerColor
        self.shimmerAngle = shimmerAngle
        self.shimmerDuration = shimmerDuration
        
        self.timer =  Timer
            .publish(every: shimmerDelay, on: RunLoop.main, in: RunLoop.Mode.default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let strongSelf = self else { return }
                if #available(iOS 15, *) {
                    withAnimation { strongSelf.isActive.toggle() }
                } else {
                    strongSelf.isActive = false
                    withAnimation { strongSelf.isActive = true }
                }
            })
        self.fireTimer = Timer
            .publish(every: 0.1, on: RunLoop.main, in: RunLoop.Mode.default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.isActive = false
                // Remove timer after fire the event
                self?.fireTimer?.cancel()
                self?.fireTimer = nil
                withAnimation { strongSelf.isActive = true }
            })
    }
    
    deinit {
        timer?.cancel()
        timer = nil
        fireTimer?.cancel()
        fireTimer = nil
    }
    
}

struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    
    public func body(content: Content) -> Self.Body {
        guard isActive else { return AnyView(content) }
        return AnyView(content.overlay(ShimmerView().cornerRadius(20))
            .padding(.horizontal, 15))
    }
    
    public typealias Body = AnyView
}

struct ShimmerView : View {
    @EnvironmentObject private var shimmerConfig: ShimmerConfig
    
    var body: some View {
        let startGradient = Gradient.Stop(color: self.shimmerConfig.bgColor, location: 0.3)
        let endGradient = Gradient.Stop(color: self.shimmerConfig.bgColor, location: 0.7)
        let maskGradient = Gradient.Stop(color: self.shimmerConfig.shimmerColor, location: 0.5)
        
        let gradient = Gradient(stops: [startGradient, maskGradient, endGradient])
        
        let linearGradient = LinearGradient(gradient: gradient,
                                            startPoint: .leading,
                                            endPoint: .trailing)
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .background(self.shimmerConfig.bgColor)
                    .foregroundColor(.clear)
                Rectangle()
                    .foregroundColor(.clear)
                    .background(linearGradient)
                    .rotationEffect(Angle(degrees: self.shimmerConfig.shimmerAngle))
                    .offset(x: self.shimmerConfig.isActive ? self.shimmerOffset(geometry.size.width) : -self.shimmerOffset(geometry.size.width), y: 0)
                    .transition(.move(edge: .leading))
                    .animation(.linear(duration: self.shimmerConfig.shimmerDuration))
            }
            .padding(EdgeInsets(top: -self.shimmerOffset(geometry.size.width),
                                leading: 0,
                                bottom: -self.shimmerOffset(geometry.size.width),
                                trailing: 0))
        }
    }
    
    func shimmerOffset(_ width: CGFloat) -> CGFloat {
        width + CGFloat(2 * self.shimmerConfig.shimmerAngle)
    }
}

extension View {
    dynamic func shimmer(isActive: Bool) -> some View {
        self.modifier(ShimmerModifier(isActive: isActive))
    }
}
