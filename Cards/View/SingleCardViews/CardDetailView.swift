//
//  CardDetailView.swift
//  Cards
//
//  Created by Павел Калинин on 24.01.2024.
//

import SwiftUI

struct CardDetailView: View {
    var proxy: GeometryProxy?
    @EnvironmentObject var store: CardStore
    @Binding var card: Card
    var viewScale: CGFloat = 1
    var body: some View {
        ZStack {
            card.backgroundColor
                .onTapGesture{
                    store.selectedElement = nil
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ForEach($card.elements, id: \.id) { $element in
                CardElementView(element: element)
                    .overlay(element: element, isSelected: isSelected(element))
                    .onTapGesture {
                        store.selectedElement = element
                    }
                    .elementContextMenu(
                        card: $card,
                        element: $element)
                    .resizableView(
                      transform: $element.transform,
                      viewScale: viewScale)
                    .frame(
                        width: element.transform.size.width,
                        height: element.transform.size.height)
                
            }
        }
        .onDisappear {
            store.selectedElement = nil
        }
        .dropDestination(for: CustomTransfer.self) { items, location in
            let offset = Settings.calculateDropOffset(proxy: proxy, location: location)
            Task {
                card.addElements(from: items, at: offset)
                
            }
            return !items.isEmpty
        }
    }
    
    func isSelected(_ element: CardElement) -> Bool{
        store.selectedElement?.id == element.id
    }
}

private extension View {
    @ViewBuilder
    func overlay(
        element: CardElement,
        isSelected: Bool
    ) -> some View {
        if isSelected,
           let element = element as? ImageElement,
           let frameIndex = element.frameIndex {
            let shape = Shapes.shapes[frameIndex]
            self.overlay(shape
                .stroke(lineWidth: Settings.borderWidth)
                .foregroundColor(Settings.borderColor))
        } else {
            self
                .border(
                    Settings.borderColor,
                    width: isSelected ? Settings.borderWidth : 0)
        }
    }
}

