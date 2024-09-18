//
//  ColorMacro.swift
//  TestMacro
//
//  Created by beforeold on 6/16/24.
//

import SwiftUI
import UIKit

@attached(member, names: named(color(_:)), named(uiColor(_:)))
macro ColorAssetMacro() = #externalMacro(module: "MyMacros", type: "ColorAssetMacroImplementation")

@ColorAssetMacro("MyColor")
struct MyColors { }

// Now you can use the generated colors like this:
let color1 = Color.MyColor
let color2 = UIColor.MyColor

// Implement the macro
@_implementation(ColorAssetMacro)
struct ColorAssetMacroImplementation {
    static func expansion(
        _ attribute: AttributeSyntax,
        _ declaration: DeclarationSyntax
    ) -> [DeclarationSyntax] {
        guard let colorName = attribute.argument?.description.trimmed else {
            fatalError("Color name is required")
        }

        let swiftUIColor = """
        extension Color {
            static var \(colorName): Color {
                Color("\(colorName)")
            }
        }
        """

        let uiColor = """
        extension UIColor {
            static var \(colorName): UIColor {
                UIColor(named: "\(colorName)")!
            }
        }
        """

        return [
            DeclarationSyntax(stringLiteral: swiftUIColor),
            DeclarationSyntax(stringLiteral: uiColor)
        ]
    }
}
