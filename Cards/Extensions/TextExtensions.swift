//
//  TextExtensions.swift
//  Cards
//
//  Created by Павел Калинин on 24.01.2024.
//

import Foundation
import SwiftUI

extension Text {
  func scalableText(font: Font = Font.system(size: 1000)) -> some View {
    self
      .font(font)
      .minimumScaleFactor(0.01)
      .lineLimit(1)
  }
}
