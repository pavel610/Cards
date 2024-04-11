//
//  CardsApp.swift
//  Cards
//
//  Created by Павел Калинин on 28.12.2023.
//

import SwiftUI

@main
struct CardsApp: App {
    @StateObject var store = CardStore(defaultData: false)
    
    var body: some Scene {
        WindowGroup {
            AppLoadingView()
                .environmentObject(store)
        }
    }
}
