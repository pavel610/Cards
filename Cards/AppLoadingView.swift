//
//  AppLoadingView.swift
//  Cards
//
//  Created by Павел Калинин on 02.02.2024.
//

import SwiftUI

struct AppLoadingView: View {
    @State private var showSplash = true
    var body: some View {
        if showSplash{
            SplashScreen()
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.linear(duration: 2)) {
                            showSplash = false
                        }
                    }
                }
        }else{
            CardsListView()
        }
    }
    
}

#Preview {
    AppLoadingView()
        .environmentObject(CardStore(defaultData: true))
}
