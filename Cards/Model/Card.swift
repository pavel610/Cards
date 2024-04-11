//
//  Card.swift
//  Cards
//
//  Created by Павел Калинин on 24.01.2024.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var backgroundColor: Color = Color("background")
    var elements: [CardElement] = []
    
    mutating func addElement(uiImage: UIImage) {
        // 1
        let imageFilename = uiImage.save()
        // 2
        let element = ImageElement(
            uiImage: uiImage,
            imageFilename: imageFilename)
        elements.append(element)
    }
    mutating func addElement(text: TextElement) {
        elements.append(text)
    }
    mutating func addElement(uiImage: UIImage, at offset: CGSize = .zero) {
        let imageFilename = uiImage.save()
        let transform = Transform(offset: offset)
        let element = ImageElement(
          transform: transform,
          uiImage: uiImage,
          imageFilename: imageFilename)
        elements.append(element)
        save()
      } 
    mutating func addElements(from transfer: [CustomTransfer], at offset: CGSize) {
        for element in transfer {
          if let text = element.text {
            addElement(text: TextElement(text: text))
          } else if let image = element.image {
            addElement(uiImage: image, at: offset)
          }
        }
      }
    
    mutating func remove(_ element: CardElement){
        if let element = element as? ImageElement {
            UIImage.remove(name: element.imageFilename)
        }
        if let index = element.index(in: elements){
            elements.remove(at: index)
        }
    }
    
    mutating func update(_ element: CardElement?, frameIndex: Int) {
        if let element = element as? ImageElement,
           let index = element.index(in: elements) {
            var newElement = element
            newElement.frameIndex = frameIndex
            elements[index] = newElement
        }
    }
    
    func save() {
        do {
            // 1
            let encoder = JSONEncoder()
            // 2
            let data = try encoder.encode(self)
            // 3
            let filename = "\(id).rwcard"
            let url = URL.documentsDirectory
                .appendingPathComponent(filename)
            // 4
            try data.write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}

extension Card: Codable {
    enum CodingKeys: CodingKey {
        case id, view, backgroundColor, imageElements, textElements
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder
            .container(keyedBy: CodingKeys.self)
        // 1
        let id = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: id) ?? UUID()
        // 2
        elements += try container
            .decode([ImageElement].self, forKey: .imageElements)
        
        elements += try container
            .decode([TextElement].self, forKey: .textElements)
        
        let components = try container.decode([CGFloat].self, forKey: .backgroundColor)
        backgroundColor = Color.color(components: components)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        let imageElements: [ImageElement] =
        elements.compactMap { $0 as? ImageElement }
        var components = backgroundColor.colorComponents()
        let textElements: [TextElement] = elements.compactMap{$0 as? TextElement}
        try container.encode(textElements, forKey: .textElements)
        try container.encode(components, forKey: .backgroundColor)
        try container.encode(imageElements, forKey: .imageElements)
    }
}
