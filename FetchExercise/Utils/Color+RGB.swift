//
//  Color+RGB.swift
//  FetchExercise
//
//  Created by Andrej Poljanec on 2/13/25.
//

import SwiftUI

extension Color {
    
    init?(rgb: String) {
        let rgbHex = rgb.uppercased().trimmingCharacters(in: CharacterSet(charactersIn: "0123456789ABCDEF").inverted)
        guard rgbHex.count == 6 else {
            return nil
        }
        var int: UInt64 = 0
        Scanner(string: rgbHex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: 1)
    }
    
}

extension Color {
    static func filterGradientStartColor() -> Color {
        return Color(rgb: "#FCB603") ?? .black
    }
    static func filterGradientEndColor() -> Color {
        return Color(rgb: "#FC7703") ?? .black
    }
}
