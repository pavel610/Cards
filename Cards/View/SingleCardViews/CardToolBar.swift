//
//  CardToolBar.swift
//  Cards
//
//  Created by Павел Калинин on 23.01.2024.
//

import SwiftUI

struct CardToolBar: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @Binding var currentModal: ToolbarSelection?
    @Binding var card: Card
    @State private var stickerImage: UIImage?
    @EnvironmentObject var store: CardStore
    @State private var frameIndex: Int?
    @State private var textElement = TextElement()
    var menu: some View {
        // 1
        Menu {
            Button {
                if let images = UIPasteboard.general.images{
                    for image in images {
                        card.addElement(uiImage: image)
                    }
                }else if let texts = UIPasteboard.general.strings{
                    for text in texts{
                        card.addElement(text: TextElement(text: text))
                    }
                }
            } label: {
                Label("Paste", systemImage: "doc.on.clipboard")
            }
            // 2
            .disabled(!UIPasteboard.general.hasImages
                      && !UIPasteboard.general.hasStrings)
        } label: {
            Label("Add", systemImage: "ellipsis.circle")
        }
        
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                menu
            }
            ToolbarItem(placement: .topBarTrailing){
                Button("Done"){
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
              let uiImage = UIImage.screenshot(
            card: card,
                size: Settings.cardSize)
              let image = Image(uiImage: uiImage)
                ShareLink(
                  item: image,
                  preview: SharePreview(
                    "Card",
                    image: image)) {
                      Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .topBarLeading){
                ColorPicker("", selection: $card.backgroundColor)
                
            }
            ToolbarItem(placement: .bottomBar) {
                BottomToolbar(
                  card: $card,
                  modal: $currentModal)
            }
            
        }
        .sheet(item: $currentModal) { item in
            switch item {
            case .stickerModal:
                StickerModal(stickerImage: $stickerImage)
                    .onDisappear {
                        if let stickerImage = stickerImage {
                            card.addElement(uiImage: stickerImage)
                        }
                        stickerImage = nil
                    }
            case .frameModal:
                FrameModal(frameIndex: $frameIndex)
                    .onDisappear {
                        if let frameIndex {
                            card.update(
                                store.selectedElement,
                                frameIndex: frameIndex)
                        }
                        frameIndex = nil
                    }
            case .textModal:
                TextModal(textElement: $textElement)
                    .onDisappear(){
                        if !textElement.text.isEmpty{
                            card.addElement(text: textElement)
                        }
                        textElement = TextElement()
                    }
            
            default:
                Text(String(describing: item))
            
            }
        }
    }
}
