//
//  CardsListView.swift
//  Cards
//
//  Created by Павел Калинин on 28.12.2023.
//

import SwiftUI

struct CardsListView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var initialView: some View {
        VStack {
            Spacer()
            let card = Card()
            ZStack {
                CardThumbnail(card: card)
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
            }
            .frame(
                width: thumbnailSize.width * 1.2,
                height: thumbnailSize.height * 1.2)
            .onTapGesture {
                selectedCard = store.addCard()
            }
            Spacer()
        }
    }
    var thumbnailSize: CGSize {
        var scale: CGFloat = 1
        if verticalSizeClass == .regular,
           horizontalSizeClass == .regular {
            scale = 1.5 }
        return Settings.thumbnailSize * scale
    }
    var createButton: some View {
        // 1
        Button {
            selectedCard = store.addCard()
        } label: {
            Label("Create New", systemImage: "plus")
                .frame(maxWidth: .infinity)
        }
        .font(.system(size: 16, weight: .bold))
        // 2
        .padding([.top, .bottom], 10)
        // 3
        .background(Color("barColor"))
        .accentColor(.white)
    }
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPresented = false
    @EnvironmentObject var store: CardStore
    @State private var selectedCard: Card?
    var columns: [GridItem] {
        [
            GridItem(.adaptive(
                minimum: thumbnailSize.width))
        ]
    }
    var body: some View {
        VStack {
            Group {
              if store.cards.isEmpty {
                initialView
              } else {
                  ScrollView(showsIndicators: false){
                      LazyVGrid(columns: columns, spacing: 30){
                          ForEach(store.cards){card in
                              CardThumbnail(card: card)
                                  .frame(
                                      width: thumbnailSize.width,
                                      height: thumbnailSize.height)
                                  .contextMenu{
                                      Button(role: .destructive){
                                          store.remove(card)
                                      }label: {
                                          Label("Delete", systemImage: "trash")
                                      }
                                  }
                                  .onTapGesture {
                                      selectedCard = card
                                  }
                                
                          }
                      }
                  }
                  .padding(.top, 20)
                  .fullScreenCover(item: $selectedCard){ card in
                      if let index = store.index(for: card) {
                          SingleCardView(card: $store.cards[index])
                              .onChange(of: scenePhase) { newScenePhase in
                                  if newScenePhase == .inactive {
                                      store.cards[index].save()
                                  }
                              }
                      } else {
                          fatalError("Unable to locate selected card")
                      }
                  }
              }
            }
            if !store.cards.isEmpty{
                createButton
            }

            
        }
        .frame(maxWidth: .infinity)
        .background(Color("LaunchColor"))
        
    }
}


#Preview {
    CardsListView()
        .environmentObject(CardStore(defaultData: true))
}

struct CardThumbnail: View {
    let card: Card
    var body: some View {
        Image(uiImage: UIImage.screenshot(
        card: card,
          size: Settings.cardSize))
        .resizable()
            .cornerRadius(10)
            .shadow(
              color: Color("shadow-color"),
              radius: 3,
              x: 0.0,
              y: 0.0)


    }
}

