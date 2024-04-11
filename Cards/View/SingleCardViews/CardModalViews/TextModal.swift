//
//  TextMoadal.swift
//  Cards
//
//  Created by Павел Калинин on 31.01.2024.
//

import SwiftUI

struct TextModal: View {
    @Environment(\.dismiss) var dismiss
    @Binding var textElement: TextElement
    var body: some View {
        let onCommit = {
            dismiss()
        }
        
        VStack {
            TextField("Write something", text: $textElement.text, onCommit: onCommit)
                .foregroundStyle(textElement.textColor)
                .font(.custom(textElement.textFont, size: 30))
                .padding(20)
            TextView(font: $textElement.textFont, color: $textElement.textColor)
        }
    }
}

#Preview {
    TextModal( textElement: .constant(TextElement()))
}
