import SwiftUI

enum Settings {
    static let cardSize =
    CGSize(width: 1300, height: 2000)
    static let thumbnailSize =
    CGSize(width: 150, height: 250)
    static let defaultElementSize =
    CGSize(width: 800, height: 800)
    static let borderColor: Color = .blue
    static let borderWidth: CGFloat = 5
}

// use this method for
// the drag and drop challenge
extension Settings {
    static func calculateDropOffset(
        proxy: GeometryProxy?,
        location: CGPoint
    ) -> CGSize {
        guard
            let proxy,
            proxy.size.width > 0 && proxy.size.height > 0
        else { return .zero }
        
        // `frame` is a CGRect bounding the whole area including margins
        // surrounding the card
        /*
         The frame is in *global* coordinates.
         To illustrate what a coordinate space is, all card offsets are saved
         with the origin being at the center of the card.
         The origin is location (0, 0).
         However, `location` is in screen coordinates,
         where the origin is at the top left of the screen.
         So you must convert from “screen space” to “card space”.
         */
        let frame = proxy.frame(in: .global)
        
        // size is the calculated card size without margins
        let size = proxy.size
        
        // margins are the frame around the card
        // plus the frame's origin, if the frame is inset
        let leftMargin = (frame.width - size.width) * 0.5 + frame.origin.x
        let topMargin = (frame.height - size.height) * 0.5 + frame.origin.y
        
        // location is in screen coordinates
        // convert location from screen space to card space
        // top left of the screen is the old origin
        // top left of the card is the new origin
        var cardLocation = CGPoint(x: location.x - leftMargin, y: location.y - topMargin)
        
        // convert cardLocation into the fixed card coordinate space
        // so that the location is in 1300 x 2000 space
        cardLocation.x = cardLocation.x / size.width * Settings.cardSize.width
        cardLocation.y = cardLocation.y / size.height * Settings.cardSize.height
        
        // calculate the offset where 0, 0 is at the center of the card
        let offset = CGSize(
            width: cardLocation.x - Settings.cardSize.width * 0.5,
            height: cardLocation.y - Settings.cardSize.height * 0.5)
        return offset
    }
    static func calculateSize(_ size: CGSize) -> CGSize {
        var newSize = size
        let ratio =
        Settings.cardSize.width / Settings.cardSize.height
        if size.width < size.height {
            newSize.height = min(size.height, newSize.width / ratio)
            newSize.width = min(size.width, newSize.height * ratio)
        } else {
            newSize.width = min(size.width, newSize.height * ratio)
            newSize.height = min(size.height, newSize.width / ratio)
        }
        return newSize
    }
    static func calculateScale(_ size: CGSize) -> CGFloat {
        let newSize = calculateSize(size)
        return newSize.width / Settings.cardSize.width
    }
}
