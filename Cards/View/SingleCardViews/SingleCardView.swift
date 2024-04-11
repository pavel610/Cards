//
//  SingleCardView.swift
//  Cards
//
//  Created by Павел Калинин on 28.12.2023.
//

import SwiftUI

struct SingleCardView: View {

    @Binding var card: Card
    @State private var currentModal: ToolbarSelection?
    var body: some View {
        NavigationStack{
            GeometryReader{proxy in
                CardDetailView(proxy: proxy,
                  card: $card,
                  viewScale: Settings.calculateScale(proxy.size))
                    .onDisappear{
                        card.save()
                    }
                    .frame(
                      width: Settings.calculateSize(proxy.size).width,
                      height: Settings.calculateSize(proxy.size).height)
                    // 2
                    .clipped()
                    // 3
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .modifier(CardToolBar(
                        currentModal: $currentModal,
                        card: $card))
            }
        }
        
    }
}

