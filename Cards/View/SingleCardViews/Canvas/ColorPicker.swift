//
//  ColorPicker.swift
//  drawing
//
//  Created by Павел Калинин on 15.04.2024.
//

import SwiftUI

struct ColorPicker: View {
    var colors: [Color] = [.red, .green, .yellow, .orange, .blue, .purple]
    @Binding var selectedColor: Color
    var body: some View {
        HStack{
            ForEach(colors, id: \.self){color in
                Image(systemName: selectedColor == color ? "smallcircle.filled.circle.fill" : "circle.fill")
                    .foregroundStyle(color)
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

#Preview {
    ColorPicker(selectedColor: .constant(.red))
}
