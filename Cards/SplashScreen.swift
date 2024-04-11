//
//  SplashScreen.swift
//  Cards
//
//  Created by Павел Калинин on 02.02.2024.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            card(letter: "S", color: "appColor1")
                .splashAnimation(finalYposition: 240, delay: 0)
            card(letter: "D", color: "appColor2")
                .splashAnimation(finalYposition: 120, delay: 0.2)
            card(letter: "R", color: "appColor3")
                .splashAnimation(finalYposition: 0, delay: 0.4)
            card(letter: "A", color: "appColor6")
                .splashAnimation(finalYposition: -120, delay: 0.6)
            card(letter: "C", color: "appColor7")
                .splashAnimation(finalYposition: -240, delay: 0.8)
        }
    }
    
    func card(letter: String, color: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .shadow(radius: 3)
                .frame(width: 120, height: 160)
                .foregroundColor(Color("background"))
            Text(letter)
                .fontWeight(.bold)
                .scalableText()
                .foregroundColor(Color(color))
                .frame(width: 80)
        }
    }
    
}

private struct SplashAnimation: ViewModifier {
    let animation = Animation.interpolatingSpring(
      mass: 0.2,
      stiffness: 80,
      damping: 5,
      initialVelocity: 0.0)
    @State private var animating = true
    let finalYPosition: CGFloat
    let delay: Double
    func body(content: Content) -> some View {
        content
            .offset(y: animating ? -700 : finalYPosition)
            .rotationEffect(
              animating ? .zero
                : Angle(degrees: Double.random(in: -10...10)))
            .animation(animation.delay(delay), value: animating)
            .onAppear {
                animating = false
            }
    }
}

private extension View {
    func splashAnimation(
        finalYposition: CGFloat,
        delay: Double
    ) -> some View {
        modifier(SplashAnimation(
            finalYPosition: finalYposition,
            delay: delay))
    }
}

#Preview {
    SplashScreen()
}
