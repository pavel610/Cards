//
//  Transform.swift
//  Cards
//
//  Created by Павел Калинин on 23.01.2024.
//

import Foundation
import SwiftUI

struct Transform {
    var size = CGSize(width: Settings.defaultElementSize.width, height: Settings.defaultElementSize.height)
  var rotation: Angle = .zero
  var offset: CGSize = .zero
}
extension Transform: Codable {}
