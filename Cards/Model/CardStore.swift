//
//  CardStore.swift
//  Cards
//
//  Created by Павел Калинин on 24.01.2024.
//

import SwiftUI

class CardStore: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedElement: CardElement?
    init(defaultData: Bool = false) {
        cards = defaultData ? initialCards : load()
    }
    
    func index(for card: Card) -> Int? {
        cards.firstIndex { $0.id == card.id }
    }
    
    func remove(_ card: Card) {
       guard let index = index(for: card) else { return }
       // remove the elements
       // remove(_:) removes the element images on disk
       for element in cards[index].elements {
         cards[index].remove(element)
       }
       // remove the card image (if there is one)
       UIImage.remove(name: card.id.uuidString)
       // remove the card details
       let path = URL.documentsDirectory
         .appendingPathComponent("\(card.id.uuidString).rwcard")
       try? FileManager.default.removeItem(at: path)
       cards.remove(at: index)
     }
    
    func addCard() -> Card {
        let card = Card(backgroundColor: Color("background"))
      cards.append(card)
      card.save()
      return card
    }
}
extension CardStore {
    // 1
    func load() -> [Card] {
        var cards: [Card] = []
        // 2
        let path = URL.documentsDirectory.path
        guard
            let enumerator = FileManager.default
                .enumerator(atPath: path),
            let files = enumerator.allObjects as? [String]
        else { return cards }
        // 3
        let cardFiles = files.filter { $0.contains(".rwcard") }
        for cardFile in cardFiles {
            do { // 4
                let path = path + "/" + cardFile
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                // 5
                let decoder = JSONDecoder()
                let card = try decoder.decode(Card.self, from: data)
                cards.append(card)
            } catch {
                print("Error: ", error.localizedDescription)
            }
        }
        return cards
    }
}
