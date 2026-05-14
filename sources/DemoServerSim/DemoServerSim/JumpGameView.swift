import SpriteKit
import SwiftUI

struct JumpGameView: View {
  @Environment(\.colorScheme) private var colorScheme
  @StateObject private var sceneStore = JumpGameSceneStore()
  @State private var selectedSkin = JumpGameSkin.cuteJelly
  @State private var selectedRole = JumpGameRole.jelly

  private var appearance: JumpGameAppearance {
    JumpGameAppearance(colorScheme)
  }

  var body: some View {
    NavigationStack {
      SpriteView(scene: sceneStore.scene)
        .background(selectedSkin.navigationBackground(for: appearance))
        .navigationTitle("Jump Blocks")
        .toolbarBackground(selectedSkin.navigationBackground(for: appearance), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(selectedSkin.toolbarScheme(for: appearance), for: .navigationBar)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Menu {
              ForEach(JumpGameRole.allCases) { role in
                Button {
                  selectedRole = role
                } label: {
                  Label(role.title, systemImage: selectedRole == role ? "checkmark.circle.fill" : role.symbol)
                }
              }
            } label: {
              Label("Role", systemImage: selectedRole.symbol)
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
              ForEach(JumpGameSkin.allCases) { skin in
                Button {
                  selectedSkin = skin
                } label: {
                  Label(skin.title, systemImage: selectedSkin == skin ? "checkmark.circle.fill" : skin.symbol)
                }
              }
            } label: {
              Label("Skin", systemImage: selectedSkin.symbol)
            }
          }
        }
        .tint(selectedSkin.accentColor(for: appearance))
        .onAppear {
          sceneStore.scene.applyAppearance(appearance)
          sceneStore.scene.applySkin(selectedSkin)
          sceneStore.scene.applyRole(selectedRole)
        }
        .onChange(of: colorScheme) { newScheme in
          sceneStore.scene.applyAppearance(JumpGameAppearance(newScheme))
        }
        .onChange(of: selectedSkin) { newSkin in
          sceneStore.scene.applySkin(newSkin)
        }
        .onChange(of: selectedRole) { newRole in
          sceneStore.scene.applyRole(newRole)
        }
    }
    .background(selectedSkin.navigationBackground(for: appearance).ignoresSafeArea())
  }
}

private enum JumpGameAppearance: Equatable {
  case light
  case dark

  init(_ colorScheme: ColorScheme) {
    self = colorScheme == .dark ? .dark : .light
  }
}

private enum JumpGameRole: String, CaseIterable, Identifiable {
  case jelly
  case bunny
  case kitten
  case panda
  case robot

  var id: String {
    rawValue
  }

  var title: String {
    switch self {
    case .jelly:
      return "Jelly Cube"
    case .bunny:
      return "Bunny Pop"
    case .kitten:
      return "Kitten Puff"
    case .panda:
      return "Panda Bean"
    case .robot:
      return "Robo Square"
    }
  }

  var symbol: String {
    switch self {
    case .jelly:
      return "face.smiling"
    case .bunny:
      return "hare.fill"
    case .kitten:
      return "cat.fill"
    case .panda:
      return "pawprint.fill"
    case .robot:
      return "app.fill"
    }
  }
}

private enum JumpGameSkin: String, CaseIterable, Identifiable {
  case cuteJelly
  case classic
  case forest
  case beach
  case sandSea

  var id: String {
    rawValue
  }

  var title: String {
    switch self {
    case .cuteJelly:
      return "Cute Jelly"
    case .classic:
      return "Classic Blocks"
    case .forest:
      return "Forest"
    case .beach:
      return "Beach"
    case .sandSea:
      return "Sand Sea"
    }
  }

  var symbol: String {
    switch self {
    case .cuteJelly:
      return "sparkles"
    case .classic:
      return "square.stack.3d.up.fill"
    case .forest:
      return "leaf.fill"
    case .beach:
      return "sun.max.fill"
    case .sandSea:
      return "water.waves"
    }
  }

  func navigationBackground(for appearance: JumpGameAppearance) -> Color {
    switch (self, appearance) {
    case (.cuteJelly, .light):
      return Color(red: 0.98, green: 0.94, blue: 1.0)
    case (.cuteJelly, .dark):
      return Color(red: 0.13, green: 0.09, blue: 0.18)
    case (.classic, .light):
      return Color(red: 0.95, green: 0.96, blue: 0.98)
    case (.classic, .dark):
      return .black
    case (.forest, .light):
      return Color(red: 0.91, green: 0.97, blue: 0.89)
    case (.forest, .dark):
      return Color(red: 0.06, green: 0.12, blue: 0.09)
    case (.beach, .light):
      return Color(red: 0.88, green: 0.97, blue: 1.0)
    case (.beach, .dark):
      return Color(red: 0.04, green: 0.10, blue: 0.17)
    case (.sandSea, .light):
      return Color(red: 0.98, green: 0.93, blue: 0.80)
    case (.sandSea, .dark):
      return Color(red: 0.09, green: 0.10, blue: 0.18)
    }
  }

  func accentColor(for appearance: JumpGameAppearance) -> Color {
    switch (self, appearance) {
    case (.cuteJelly, .light):
      return Color(red: 0.83, green: 0.24, blue: 0.44)
    case (.cuteJelly, .dark):
      return Color(red: 1.0, green: 0.52, blue: 0.72)
    case (.classic, .light):
      return Color(red: 0.0, green: 0.34, blue: 0.72)
    case (.classic, .dark):
      return Color(red: 0.0, green: 0.56, blue: 1.0)
    case (.forest, .light):
      return Color(red: 0.12, green: 0.48, blue: 0.22)
    case (.forest, .dark):
      return Color(red: 0.42, green: 0.85, blue: 0.38)
    case (.beach, .light):
      return Color(red: 0.0, green: 0.47, blue: 0.78)
    case (.beach, .dark):
      return Color(red: 0.35, green: 0.80, blue: 1.0)
    case (.sandSea, .light):
      return Color(red: 0.0, green: 0.47, blue: 0.54)
    case (.sandSea, .dark):
      return Color(red: 0.96, green: 0.72, blue: 0.31)
    }
  }

  func toolbarScheme(for appearance: JumpGameAppearance) -> ColorScheme {
    switch appearance {
    case .light:
      return .light
    case .dark:
      return .dark
    }
  }

  func materials(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch self {
    case .cuteJelly:
      return JumpGameSkinMaterials.cuteJelly(for: appearance)
    case .classic:
      return JumpGameSkinMaterials.classic(for: appearance)
    case .forest:
      return JumpGameSkinMaterials.forest(for: appearance)
    case .beach:
      return JumpGameSkinMaterials.beach(for: appearance)
    case .sandSea:
      return JumpGameSkinMaterials.sandSea(for: appearance)
    }
  }
}

private struct JumpGameSkinMaterials {
  let sceneBackground: SKColor
  let hudPrimary: SKColor
  let hudSecondary: SKColor
  let message: SKColor
  let powerTrack: SKColor
  let powerFill: SKColor
  let playerFill: SKColor
  let playerStroke: SKColor
  let playerGloss: SKColor
  let face: SKColor
  let blush: SKColor
  let platformPalette: [SKColor]
  let platformStroke: SKColor
  let platformGloss: SKColor
  let platformShadow: SKColor
  let bubble: SKColor
  let playerCornerRadius: CGFloat
  let platformCornerRadius: CGFloat
  let playerGlow: CGFloat
  let platformGlow: CGFloat
  let chargeWide: CGFloat
  let chargeSquash: CGFloat
  let jumpRotation: CGFloat
  let showsJellyDetails: Bool
}

private extension JumpGameSkinMaterials {
  static func cuteJelly(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch appearance {
    case .light:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.98, green: 0.94, blue: 1.0, alpha: 1),
        hudPrimary: SKColor(red: 0.28, green: 0.12, blue: 0.34, alpha: 1),
        hudSecondary: SKColor(red: 0.51, green: 0.36, blue: 0.55, alpha: 1),
        message: SKColor(red: 0.83, green: 0.24, blue: 0.44, alpha: 1),
        powerTrack: SKColor(white: 1, alpha: 0.68),
        powerFill: SKColor(red: 1.0, green: 0.35, blue: 0.57, alpha: 1),
        playerFill: SKColor(red: 0.48, green: 0.94, blue: 0.9, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.72),
        playerGloss: SKColor(white: 1, alpha: 0.62),
        face: SKColor(red: 0.23, green: 0.13, blue: 0.24, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.44, blue: 0.61, alpha: 0.72),
        platformPalette: [
          SKColor(red: 1.0, green: 0.48, blue: 0.62, alpha: 1),
          SKColor(red: 0.68, green: 0.54, blue: 1.0, alpha: 1),
          SKColor(red: 0.49, green: 0.9, blue: 0.66, alpha: 1),
          SKColor(red: 1.0, green: 0.79, blue: 0.33, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.56),
        platformGloss: SKColor(white: 1, alpha: 0.42),
        platformShadow: SKColor(red: 0.54, green: 0.3, blue: 0.64, alpha: 0.22),
        bubble: SKColor(white: 1, alpha: 0.36),
        playerCornerRadius: 13,
        platformCornerRadius: 18,
        playerGlow: 4,
        platformGlow: 3,
        chargeWide: 0.16,
        chargeSquash: 0.22,
        jumpRotation: .pi * 0.35,
        showsJellyDetails: true
      )
    case .dark:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.13, green: 0.09, blue: 0.18, alpha: 1),
        hudPrimary: SKColor(red: 0.98, green: 0.93, blue: 1.0, alpha: 1),
        hudSecondary: SKColor(red: 0.77, green: 0.67, blue: 0.86, alpha: 1),
        message: SKColor(red: 1.0, green: 0.61, blue: 0.77, alpha: 1),
        powerTrack: SKColor(white: 1, alpha: 0.17),
        powerFill: SKColor(red: 1.0, green: 0.42, blue: 0.67, alpha: 1),
        playerFill: SKColor(red: 0.48, green: 0.96, blue: 0.94, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.42),
        playerGloss: SKColor(white: 1, alpha: 0.38),
        face: SKColor(red: 0.13, green: 0.07, blue: 0.18, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.49, blue: 0.7, alpha: 0.78),
        platformPalette: [
          SKColor(red: 1.0, green: 0.39, blue: 0.66, alpha: 1),
          SKColor(red: 0.66, green: 0.49, blue: 1.0, alpha: 1),
          SKColor(red: 0.4, green: 0.88, blue: 0.72, alpha: 1),
          SKColor(red: 1.0, green: 0.78, blue: 0.32, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.3),
        platformGloss: SKColor(white: 1, alpha: 0.26),
        platformShadow: SKColor(white: 0, alpha: 0.34),
        bubble: SKColor(white: 1, alpha: 0.25),
        playerCornerRadius: 13,
        platformCornerRadius: 18,
        playerGlow: 7,
        platformGlow: 5,
        chargeWide: 0.16,
        chargeSquash: 0.22,
        jumpRotation: .pi * 0.35,
        showsJellyDetails: true
      )
    }
  }

  static func classic(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch appearance {
    case .light:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1),
        hudPrimary: SKColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1),
        hudSecondary: SKColor(red: 0.38, green: 0.4, blue: 0.43, alpha: 1),
        message: SKColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1),
        powerTrack: SKColor(white: 0, alpha: 0.11),
        powerFill: SKColor(red: 0.0, green: 0.43, blue: 0.93, alpha: 1),
        playerFill: .white,
        playerStroke: SKColor(white: 0, alpha: 0.16),
        playerGloss: SKColor(white: 1, alpha: 0.3),
        face: .clear,
        blush: .clear,
        platformPalette: [
          SKColor(red: 0.04, green: 0.56, blue: 0.54, alpha: 1),
          SKColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 1),
          SKColor(red: 0.95, green: 0.46, blue: 0.16, alpha: 1),
          SKColor(red: 0.2, green: 0.62, blue: 0.28, alpha: 1)
        ],
        platformStroke: SKColor(white: 0, alpha: 0.12),
        platformGloss: SKColor(white: 1, alpha: 0.26),
        platformShadow: .clear,
        bubble: .clear,
        playerCornerRadius: 9,
        platformCornerRadius: 14,
        playerGlow: 0,
        platformGlow: 0,
        chargeWide: 0.12,
        chargeSquash: 0.18,
        jumpRotation: .pi * 2,
        showsJellyDetails: false
      )
    case .dark:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.06, green: 0.065, blue: 0.075, alpha: 1),
        hudPrimary: .white,
        hudSecondary: SKColor(white: 0.68, alpha: 1),
        message: .white,
        powerTrack: SKColor(white: 1, alpha: 0.16),
        powerFill: SKColor(red: 0.0, green: 0.56, blue: 1, alpha: 1),
        playerFill: .white,
        playerStroke: SKColor(white: 0, alpha: 0.2),
        playerGloss: SKColor(white: 1, alpha: 0.18),
        face: .clear,
        blush: .clear,
        platformPalette: [
          SKColor(red: 0.04, green: 0.5, blue: 0.49, alpha: 1),
          SKColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 1),
          SKColor(red: 0.95, green: 0.46, blue: 0.16, alpha: 1),
          SKColor(red: 0.2, green: 0.62, blue: 0.28, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.12),
        platformGloss: SKColor(white: 1, alpha: 0.14),
        platformShadow: .clear,
        bubble: .clear,
        playerCornerRadius: 9,
        platformCornerRadius: 14,
        playerGlow: 0,
        platformGlow: 0,
        chargeWide: 0.12,
        chargeSquash: 0.18,
        jumpRotation: .pi * 2,
        showsJellyDetails: false
      )
    }
  }

  static func forest(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch appearance {
    case .light:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.91, green: 0.97, blue: 0.89, alpha: 1),
        hudPrimary: SKColor(red: 0.08, green: 0.26, blue: 0.13, alpha: 1),
        hudSecondary: SKColor(red: 0.28, green: 0.45, blue: 0.26, alpha: 1),
        message: SKColor(red: 0.57, green: 0.35, blue: 0.08, alpha: 1),
        powerTrack: SKColor(red: 0.16, green: 0.36, blue: 0.18, alpha: 0.12),
        powerFill: SKColor(red: 0.15, green: 0.6, blue: 0.26, alpha: 1),
        playerFill: SKColor(red: 0.72, green: 0.94, blue: 0.66, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.62),
        playerGloss: SKColor(white: 1, alpha: 0.46),
        face: SKColor(red: 0.08, green: 0.2, blue: 0.12, alpha: 1),
        blush: SKColor(red: 0.97, green: 0.48, blue: 0.42, alpha: 0.66),
        platformPalette: [
          SKColor(red: 0.2, green: 0.65, blue: 0.31, alpha: 1),
          SKColor(red: 0.47, green: 0.36, blue: 0.17, alpha: 1),
          SKColor(red: 0.44, green: 0.74, blue: 0.25, alpha: 1),
          SKColor(red: 0.93, green: 0.69, blue: 0.25, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.34),
        platformGloss: SKColor(white: 1, alpha: 0.28),
        platformShadow: SKColor(red: 0.12, green: 0.32, blue: 0.13, alpha: 0.18),
        bubble: SKColor(red: 0.89, green: 1.0, blue: 0.86, alpha: 0.34),
        playerCornerRadius: 12,
        platformCornerRadius: 16,
        playerGlow: 2,
        platformGlow: 2,
        chargeWide: 0.14,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.28,
        showsJellyDetails: true
      )
    case .dark:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.06, green: 0.12, blue: 0.09, alpha: 1),
        hudPrimary: SKColor(red: 0.9, green: 1.0, blue: 0.84, alpha: 1),
        hudSecondary: SKColor(red: 0.61, green: 0.76, blue: 0.58, alpha: 1),
        message: SKColor(red: 0.98, green: 0.74, blue: 0.34, alpha: 1),
        powerTrack: SKColor(white: 1, alpha: 0.15),
        powerFill: SKColor(red: 0.46, green: 0.86, blue: 0.36, alpha: 1),
        playerFill: SKColor(red: 0.58, green: 0.86, blue: 0.53, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.34),
        playerGloss: SKColor(white: 1, alpha: 0.32),
        face: SKColor(red: 0.04, green: 0.11, blue: 0.06, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.5, blue: 0.48, alpha: 0.72),
        platformPalette: [
          SKColor(red: 0.12, green: 0.49, blue: 0.24, alpha: 1),
          SKColor(red: 0.36, green: 0.26, blue: 0.12, alpha: 1),
          SKColor(red: 0.35, green: 0.68, blue: 0.21, alpha: 1),
          SKColor(red: 0.86, green: 0.62, blue: 0.22, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.22),
        platformGloss: SKColor(white: 1, alpha: 0.2),
        platformShadow: SKColor(white: 0, alpha: 0.3),
        bubble: SKColor(red: 0.82, green: 1.0, blue: 0.76, alpha: 0.24),
        playerCornerRadius: 12,
        platformCornerRadius: 16,
        playerGlow: 5,
        platformGlow: 3,
        chargeWide: 0.14,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.28,
        showsJellyDetails: true
      )
    }
  }

  static func beach(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch appearance {
    case .light:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.88, green: 0.97, blue: 1.0, alpha: 1),
        hudPrimary: SKColor(red: 0.04, green: 0.27, blue: 0.43, alpha: 1),
        hudSecondary: SKColor(red: 0.24, green: 0.5, blue: 0.61, alpha: 1),
        message: SKColor(red: 0.88, green: 0.28, blue: 0.2, alpha: 1),
        powerTrack: SKColor(red: 0.03, green: 0.41, blue: 0.56, alpha: 0.12),
        powerFill: SKColor(red: 0.97, green: 0.43, blue: 0.33, alpha: 1),
        playerFill: SKColor(red: 0.56, green: 0.93, blue: 0.86, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.66),
        playerGloss: SKColor(white: 1, alpha: 0.5),
        face: SKColor(red: 0.03, green: 0.2, blue: 0.29, alpha: 1),
        blush: SKColor(red: 0.98, green: 0.45, blue: 0.42, alpha: 0.66),
        platformPalette: [
          SKColor(red: 0.96, green: 0.78, blue: 0.43, alpha: 1),
          SKColor(red: 0.18, green: 0.72, blue: 0.8, alpha: 1),
          SKColor(red: 0.97, green: 0.46, blue: 0.36, alpha: 1),
          SKColor(red: 0.97, green: 0.9, blue: 0.57, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.44),
        platformGloss: SKColor(white: 1, alpha: 0.34),
        platformShadow: SKColor(red: 0.04, green: 0.43, blue: 0.5, alpha: 0.18),
        bubble: SKColor(white: 1, alpha: 0.42),
        playerCornerRadius: 13,
        platformCornerRadius: 17,
        playerGlow: 3,
        platformGlow: 2,
        chargeWide: 0.15,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.32,
        showsJellyDetails: true
      )
    case .dark:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.04, green: 0.1, blue: 0.17, alpha: 1),
        hudPrimary: SKColor(red: 0.89, green: 0.98, blue: 1.0, alpha: 1),
        hudSecondary: SKColor(red: 0.58, green: 0.78, blue: 0.86, alpha: 1),
        message: SKColor(red: 1.0, green: 0.58, blue: 0.48, alpha: 1),
        powerTrack: SKColor(white: 1, alpha: 0.15),
        powerFill: SKColor(red: 0.38, green: 0.82, blue: 1.0, alpha: 1),
        playerFill: SKColor(red: 0.46, green: 0.89, blue: 0.86, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.34),
        playerGloss: SKColor(white: 1, alpha: 0.3),
        face: SKColor(red: 0.02, green: 0.12, blue: 0.18, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.55, blue: 0.52, alpha: 0.72),
        platformPalette: [
          SKColor(red: 0.82, green: 0.63, blue: 0.32, alpha: 1),
          SKColor(red: 0.1, green: 0.56, blue: 0.68, alpha: 1),
          SKColor(red: 0.86, green: 0.33, blue: 0.31, alpha: 1),
          SKColor(red: 0.87, green: 0.79, blue: 0.44, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.24),
        platformGloss: SKColor(white: 1, alpha: 0.2),
        platformShadow: SKColor(white: 0, alpha: 0.32),
        bubble: SKColor(white: 1, alpha: 0.26),
        playerCornerRadius: 13,
        platformCornerRadius: 17,
        playerGlow: 5,
        platformGlow: 3,
        chargeWide: 0.15,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.32,
        showsJellyDetails: true
      )
    }
  }

  static func sandSea(for appearance: JumpGameAppearance) -> JumpGameSkinMaterials {
    switch appearance {
    case .light:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.98, green: 0.93, blue: 0.8, alpha: 1),
        hudPrimary: SKColor(red: 0.25, green: 0.19, blue: 0.11, alpha: 1),
        hudSecondary: SKColor(red: 0.45, green: 0.37, blue: 0.24, alpha: 1),
        message: SKColor(red: 0.0, green: 0.47, blue: 0.54, alpha: 1),
        powerTrack: SKColor(red: 0.3, green: 0.2, blue: 0.08, alpha: 0.13),
        powerFill: SKColor(red: 0.0, green: 0.58, blue: 0.63, alpha: 1),
        playerFill: SKColor(red: 0.98, green: 0.82, blue: 0.46, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.6),
        playerGloss: SKColor(white: 1, alpha: 0.42),
        face: SKColor(red: 0.23, green: 0.15, blue: 0.08, alpha: 1),
        blush: SKColor(red: 0.98, green: 0.42, blue: 0.28, alpha: 0.64),
        platformPalette: [
          SKColor(red: 0.93, green: 0.67, blue: 0.31, alpha: 1),
          SKColor(red: 0.0, green: 0.58, blue: 0.63, alpha: 1),
          SKColor(red: 0.77, green: 0.45, blue: 0.28, alpha: 1),
          SKColor(red: 0.94, green: 0.85, blue: 0.53, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.34),
        platformGloss: SKColor(white: 1, alpha: 0.3),
        platformShadow: SKColor(red: 0.49, green: 0.3, blue: 0.08, alpha: 0.2),
        bubble: SKColor(red: 0.84, green: 1.0, blue: 1.0, alpha: 0.34),
        playerCornerRadius: 11,
        platformCornerRadius: 15,
        playerGlow: 2,
        platformGlow: 2,
        chargeWide: 0.14,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.3,
        showsJellyDetails: true
      )
    case .dark:
      return JumpGameSkinMaterials(
        sceneBackground: SKColor(red: 0.09, green: 0.1, blue: 0.18, alpha: 1),
        hudPrimary: SKColor(red: 1.0, green: 0.91, blue: 0.68, alpha: 1),
        hudSecondary: SKColor(red: 0.74, green: 0.67, blue: 0.53, alpha: 1),
        message: SKColor(red: 0.53, green: 0.91, blue: 0.94, alpha: 1),
        powerTrack: SKColor(white: 1, alpha: 0.15),
        powerFill: SKColor(red: 0.36, green: 0.82, blue: 0.86, alpha: 1),
        playerFill: SKColor(red: 0.94, green: 0.69, blue: 0.36, alpha: 1),
        playerStroke: SKColor(white: 1, alpha: 0.3),
        playerGloss: SKColor(white: 1, alpha: 0.28),
        face: SKColor(red: 0.17, green: 0.11, blue: 0.08, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.48, blue: 0.34, alpha: 0.72),
        platformPalette: [
          SKColor(red: 0.8, green: 0.52, blue: 0.22, alpha: 1),
          SKColor(red: 0.0, green: 0.48, blue: 0.58, alpha: 1),
          SKColor(red: 0.62, green: 0.34, blue: 0.21, alpha: 1),
          SKColor(red: 0.86, green: 0.74, blue: 0.42, alpha: 1)
        ],
        platformStroke: SKColor(white: 1, alpha: 0.22),
        platformGloss: SKColor(white: 1, alpha: 0.18),
        platformShadow: SKColor(white: 0, alpha: 0.32),
        bubble: SKColor(red: 0.74, green: 0.96, blue: 1.0, alpha: 0.22),
        playerCornerRadius: 11,
        platformCornerRadius: 15,
        playerGlow: 5,
        platformGlow: 3,
        chargeWide: 0.14,
        chargeSquash: 0.2,
        jumpRotation: .pi * 0.3,
        showsJellyDetails: true
      )
    }
  }
}

private final class JumpGameSceneStore: ObservableObject {
  let scene: JumpGameScene

  init() {
    scene = JumpGameScene(size: CGSize(width: 390, height: 844))
    scene.scaleMode = .resizeFill
  }
}

private final class JumpGameScene: SKScene {
  private struct Platform {
    let node: SKShapeNode
    let centerX: CGFloat
    let width: CGFloat
    let height: CGFloat
    let paletteIndex: Int
  }

  private struct PlayerRoleStyle {
    let body: SKColor
    let stroke: SKColor
    let gloss: SKColor
    let eye: SKColor
    let blush: SKColor
    let detail: SKColor
    let cornerRadius: CGFloat
    let glow: CGFloat
  }

  private let worldNode = SKNode()
  private let playerNode = SKShapeNode(rectOf: CGSize(width: 34, height: 34), cornerRadius: 9)
  private let scoreLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
  private let bestLabel = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
  private let messageLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
  private let powerTrack = SKShapeNode()
  private let powerFill = SKShapeNode()

  private var currentPlatform: Platform?
  private var targetPlatform: Platform?
  private var didConfigure = false
  private var isCharging = false
  private var isJumping = false
  private var isGameOver = false
  private var charge: CGFloat = 0
  private var lastUpdateTime: TimeInterval = 0
  private var score = 0
  private var bestScore = UserDefaults.standard.integer(forKey: "JumpBlocksBestScore")
  private var activeSkin = JumpGameSkin.cuteJelly
  private var activeAppearance = JumpGameAppearance.light
  private var activeRole = JumpGameRole.jelly

  private var materials: JumpGameSkinMaterials {
    activeSkin.materials(for: activeAppearance)
  }

  private var basePlayerScale: CGFloat {
    1
  }

  private var groundY: CGFloat {
    max(210, size.height * 0.34)
  }

  override func didMove(to view: SKView) {
    view.allowsTransparency = false
    view.ignoresSiblingOrder = true
    configureIfNeeded()
  }

  override func didChangeSize(_ oldSize: CGSize) {
    layoutScene()
  }

  override func update(_ currentTime: TimeInterval) {
    let delta = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
    lastUpdateTime = currentTime

    guard isCharging, !isJumping else {
      return
    }

    charge = min(1, charge + CGFloat(delta) * 0.85)
    updatePowerMeter()
    playerNode.xScale = basePlayerScale + charge * materials.chargeWide
    playerNode.yScale = basePlayerScale - charge * materials.chargeSquash
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isGameOver {
      resetGame()
      return
    }

    guard !isJumping else {
      return
    }

    isCharging = true
    charge = 0
    messageLabel.text = ""
    updatePowerMeter()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    releaseJump()
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    releaseJump()
  }

  private func configureIfNeeded() {
    guard !didConfigure else {
      return
    }

    didConfigure = true
    addChild(worldNode)
    configureHUD()
    applySkin(activeSkin)
    resetGame()
  }

  private func configureHUD() {
    scoreLabel.fontSize = 30
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.verticalAlignmentMode = .center
    addChild(scoreLabel)

    bestLabel.fontSize = 14
    bestLabel.horizontalAlignmentMode = .left
    bestLabel.verticalAlignmentMode = .center
    addChild(bestLabel)

    messageLabel.fontSize = 28
    messageLabel.horizontalAlignmentMode = .center
    messageLabel.verticalAlignmentMode = .center
    addChild(messageLabel)

    powerTrack.strokeColor = .clear
    addChild(powerTrack)

    powerFill.strokeColor = .clear
    addChild(powerFill)
  }

  private func layoutScene() {
    guard didConfigure, size.width > 0, size.height > 0 else {
      return
    }

    scoreLabel.position = CGPoint(x: 24, y: size.height - 68)
    bestLabel.position = CGPoint(x: 26, y: size.height - 102)
    messageLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.62)
    powerTrack.path = CGPath(
      roundedRect: CGRect(x: 0, y: -5, width: min(240, size.width - 80), height: 10),
      cornerWidth: 5,
      cornerHeight: 5,
      transform: nil
    )
    powerTrack.position = CGPoint(x: 40, y: max(142, size.height * 0.14))
    updatePowerMeter()
  }

  private func resetGame() {
    worldNode.removeAllChildren()
    worldNode.position = .zero
    isCharging = false
    isJumping = false
    isGameOver = false
    charge = 0
    score = 0
    updateLabels()
    updatePowerMeter()
    messageLabel.text = ""

    let first = makePlatform(centerX: 110, width: 112, paletteIndex: 1)
    let second = makeNextPlatform(after: first)
    currentPlatform = first
    targetPlatform = second

    worldNode.addChild(first.node)
    worldNode.addChild(second.node)

    playerNode.position = CGPoint(x: first.centerX, y: groundY + first.height / 2 + 24)
    playerNode.zRotation = 0
    playerNode.setScale(1)
    applyPlayerStyle()
    worldNode.addChild(playerNode)
    layoutScene()
  }

  private func makePlatform(centerX: CGFloat, width: CGFloat, paletteIndex: Int) -> Platform {
    let height: CGFloat = 48
    let node = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: materials.platformCornerRadius)
    node.position = CGPoint(x: centerX, y: groundY)

    let platform = Platform(
      node: node,
      centerX: centerX,
      width: width,
      height: height,
      paletteIndex: paletteIndex
    )
    applyPlatformStyle(to: platform)

    return platform
  }

  private func makeNextPlatform(after platform: Platform) -> Platform {
    let width = CGFloat.random(in: 86...132)
    let distance = CGFloat.random(in: 170...280)
    let centerX = platform.centerX + distance
    let paletteIndex = Int.random(in: 0..<materials.platformPalette.count)

    return makePlatform(centerX: centerX, width: width, paletteIndex: paletteIndex)
  }

  private func releaseJump() {
    guard isCharging, !isJumping, !isGameOver else {
      return
    }

    isCharging = false
    isJumping = true
    updatePowerMeter()

    guard let currentPlatform, let targetPlatform else {
      return
    }

    let start = playerNode.position
    let distance = 78 + charge * 340
    let landingX = start.x + distance
    let arcHeight = 90 + charge * 110
    let duration = 0.42 + TimeInterval(charge) * 0.18

    let jump = SKAction.customAction(withDuration: duration) { [start] node, elapsed in
      let progress = max(0, min(1, elapsed / CGFloat(duration)))
      let x = start.x + distance * progress
      let y = start.y + sin(progress * .pi) * arcHeight
      node.position = CGPoint(x: x, y: y)
    }
    jump.timingMode = .easeOut

    let rotate = SKAction.rotate(byAngle: materials.jumpRotation, duration: duration)
    let scaleBack = SKAction.scale(to: 1, duration: 0.12)
    let land = SKAction.group([jump, rotate, scaleBack])

    playerNode.run(land) { [weak self] in
      self?.finishJump(landingX: landingX, current: currentPlatform, target: targetPlatform)
    }
  }

  private func finishJump(landingX: CGFloat, current: Platform, target: Platform) {
    let hitTarget = abs(landingX - target.centerX) <= target.width / 2

    guard hitTarget else {
      finishFailure(landingX: landingX, target: target)
      return
    }

    score += 1
    if score > bestScore {
      bestScore = score
      UserDefaults.standard.set(bestScore, forKey: "JumpBlocksBestScore")
    }

    updateLabels()
    playerNode.position = CGPoint(x: target.centerX, y: groundY + target.height / 2 + 24)
    playLandingPulse()

    let offset = target.centerX - current.centerX
    let shift = SKAction.moveBy(x: -offset, y: 0, duration: 0.24)
    shift.timingMode = .easeInEaseOut

    worldNode.run(shift) { [weak self] in
      guard let self else {
        return
      }

      current.node.removeFromParent()
      self.currentPlatform = target

      let next = self.makeNextPlatform(after: target)
      self.targetPlatform = next
      self.worldNode.addChild(next.node)
      self.isJumping = false
      self.charge = 0
      self.updatePowerMeter()
    }
  }

  private func finishFailure(landingX: CGFloat, target: Platform) {
    let missedLeft = landingX < target.centerX
    let fallX = landingX + (missedLeft ? -18 : 18)
    let fall = SKAction.move(to: CGPoint(x: fallX, y: -80), duration: 0.34)
    fall.timingMode = .easeIn

    playerNode.run(fall) { [weak self] in
      guard let self else {
        return
      }

      self.isJumping = false
      self.isGameOver = true
      self.charge = 0
      self.updatePowerMeter()
      self.messageLabel.text = "Game Over"
    }
  }

  func applySkin(_ skin: JumpGameSkin) {
    activeSkin = skin
    refreshSceneMaterialsIfNeeded()
  }

  func applyAppearance(_ appearance: JumpGameAppearance) {
    activeAppearance = appearance
    refreshSceneMaterialsIfNeeded()
  }

  func applyRole(_ role: JumpGameRole) {
    activeRole = role

    guard didConfigure else {
      return
    }

    applyPlayerStyle()
  }

  private func refreshSceneMaterialsIfNeeded() {
    guard didConfigure else {
      return
    }

    backgroundColor = materials.sceneBackground
    applyHUDStyle()
    applyPlayerStyle()

    if let currentPlatform {
      applyPlatformStyle(to: currentPlatform)
    }

    if let targetPlatform {
      applyPlatformStyle(to: targetPlatform)
    }

    updatePowerMeter()
  }

  private func applyHUDStyle() {
    scoreLabel.fontColor = materials.hudPrimary
    bestLabel.fontColor = materials.hudSecondary
    messageLabel.fontColor = materials.message
    powerTrack.fillColor = materials.powerTrack
    powerFill.fillColor = materials.powerFill
  }

  private func applyPlayerStyle() {
    let style = playerRoleStyle()
    let side: CGFloat = 34
    let rect = CGRect(x: -side / 2, y: -side / 2, width: side, height: side)
    playerNode.path = CGPath(
      roundedRect: rect,
      cornerWidth: style.cornerRadius,
      cornerHeight: style.cornerRadius,
      transform: nil
    )
    playerNode.fillColor = style.body
    playerNode.strokeColor = style.stroke
    playerNode.lineWidth = materials.showsJellyDetails ? 2 : 1
    playerNode.glowWidth = style.glow
    playerNode.removeAllChildren()

    switch activeRole {
    case .jelly:
      addSoftFace(style: style)
    case .bunny:
      addBunnyParts(style: style)
      addSoftFace(style: style)
    case .kitten:
      addKittenParts(style: style)
    case .panda:
      addPandaParts(style: style)
    case .robot:
      addRobotParts(style: style)
    }
  }

  private func playerRoleStyle() -> PlayerRoleStyle {
    switch activeRole {
    case .jelly:
      return PlayerRoleStyle(
        body: materials.playerFill,
        stroke: materials.playerStroke,
        gloss: materials.playerGloss,
        eye: materials.face,
        blush: materials.blush,
        detail: materials.face,
        cornerRadius: materials.playerCornerRadius,
        glow: materials.playerGlow
      )
    case .bunny:
      return PlayerRoleStyle(
        body: SKColor(red: 1.0, green: 0.93, blue: 0.97, alpha: 1),
        stroke: SKColor(white: 1, alpha: 0.82),
        gloss: SKColor(white: 1, alpha: 0.7),
        eye: SKColor(red: 0.22, green: 0.13, blue: 0.24, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.48, blue: 0.64, alpha: 0.74),
        detail: SKColor(red: 1.0, green: 0.54, blue: 0.7, alpha: 1),
        cornerRadius: 15,
        glow: 4
      )
    case .kitten:
      return PlayerRoleStyle(
        body: SKColor(red: 1.0, green: 0.76, blue: 0.45, alpha: 1),
        stroke: SKColor(white: 1, alpha: 0.64),
        gloss: SKColor(white: 1, alpha: 0.5),
        eye: SKColor(red: 0.22, green: 0.13, blue: 0.24, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.46, blue: 0.58, alpha: 0.7),
        detail: SKColor(red: 0.46, green: 0.22, blue: 0.08, alpha: 1),
        cornerRadius: 12,
        glow: 3
      )
    case .panda:
      return PlayerRoleStyle(
        body: SKColor(white: 0.98, alpha: 1),
        stroke: SKColor(white: 1, alpha: 0.74),
        gloss: SKColor(white: 1, alpha: 0.56),
        eye: SKColor(red: 0.15, green: 0.11, blue: 0.16, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.48, blue: 0.62, alpha: 0.62),
        detail: SKColor(red: 0.15, green: 0.11, blue: 0.16, alpha: 1),
        cornerRadius: 15,
        glow: 3
      )
    case .robot:
      return PlayerRoleStyle(
        body: SKColor(red: 0.62, green: 0.48, blue: 1.0, alpha: 1),
        stroke: SKColor(white: 1, alpha: 0.72),
        gloss: SKColor(white: 1, alpha: 0.44),
        eye: SKColor(red: 0.52, green: 0.98, blue: 1.0, alpha: 1),
        blush: SKColor(red: 1.0, green: 0.45, blue: 0.68, alpha: 0.64),
        detail: SKColor(red: 0.25, green: 0.16, blue: 0.46, alpha: 1),
        cornerRadius: 7,
        glow: 4
      )
    }
  }

  private func addGloss(_ color: SKColor) {
    let gloss = SKShapeNode(ellipseIn: CGRect(x: -10, y: 4, width: 15, height: 8))
    gloss.fillColor = color
    gloss.strokeColor = .clear
    gloss.zPosition = 2
    playerNode.addChild(gloss)
  }

  private func addSoftFace(style: PlayerRoleStyle) {
    addGloss(style.gloss)

    let faceNodes = [
      makeFaceDot(position: CGPoint(x: -7, y: -2), radius: 2.1, color: style.eye),
      makeFaceDot(position: CGPoint(x: 7, y: -2), radius: 2.1, color: style.eye),
      makeFaceDot(position: CGPoint(x: -11, y: -7), radius: 2.3, color: style.blush),
      makeFaceDot(position: CGPoint(x: 11, y: -7), radius: 2.3, color: style.blush),
      makeSmile(color: style.detail, y: -7)
    ]

    faceNodes.forEach {
      $0.zPosition = 3
      playerNode.addChild($0)
    }
  }

  private func addBunnyParts(style: PlayerRoleStyle) {
    let leftEar = makeRoundedNode(
      rect: CGRect(x: -14, y: 12, width: 8, height: 24),
      radius: 4,
      fill: style.body,
      stroke: style.stroke
    )
    let rightEar = makeRoundedNode(
      rect: CGRect(x: 6, y: 12, width: 8, height: 24),
      radius: 4,
      fill: style.body,
      stroke: style.stroke
    )
    let leftInner = makeRoundedNode(
      rect: CGRect(x: -12.2, y: 17, width: 4.5, height: 14),
      radius: 2.2,
      fill: style.detail,
      stroke: .clear
    )
    let rightInner = makeRoundedNode(
      rect: CGRect(x: 7.8, y: 17, width: 4.5, height: 14),
      radius: 2.2,
      fill: style.detail,
      stroke: .clear
    )

    [leftEar, rightEar, leftInner, rightInner].forEach {
      $0.zPosition = -1
      playerNode.addChild($0)
    }
  }

  private func addKittenParts(style: PlayerRoleStyle) {
    let leftEar = makeTriangleNode(
      points: [
        CGPoint(x: -15, y: 12),
        CGPoint(x: -8, y: 25),
        CGPoint(x: -2, y: 12)
      ],
      fill: style.body,
      stroke: style.stroke
    )
    let rightEar = makeTriangleNode(
      points: [
        CGPoint(x: 2, y: 12),
        CGPoint(x: 8, y: 25),
        CGPoint(x: 15, y: 12)
      ],
      fill: style.body,
      stroke: style.stroke
    )
    let leftInner = makeTriangleNode(
      points: [
        CGPoint(x: -11.8, y: 13.7),
        CGPoint(x: -8, y: 20.6),
        CGPoint(x: -4.5, y: 13.7)
      ],
      fill: style.blush,
      stroke: .clear
    )
    let rightInner = makeTriangleNode(
      points: [
        CGPoint(x: 4.5, y: 13.7),
        CGPoint(x: 8, y: 20.6),
        CGPoint(x: 11.8, y: 13.7)
      ],
      fill: style.blush,
      stroke: .clear
    )

    [leftEar, rightEar, leftInner, rightInner].forEach {
      $0.zPosition = -1
      playerNode.addChild($0)
    }

    addGloss(style.gloss)
    makeFaceDot(position: CGPoint(x: -7, y: -1.5), radius: 2.0, color: style.eye).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 7, y: -1.5), radius: 2.0, color: style.eye).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 0, y: -6), radius: 1.8, color: style.blush).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: -11, y: -8), radius: 2.2, color: style.blush).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 11, y: -8), radius: 2.2, color: style.blush).add(to: playerNode, zPosition: 3)

    [
      makeLine(from: CGPoint(x: -5, y: -7), to: CGPoint(x: -14, y: -4), color: style.detail, width: 0.9),
      makeLine(from: CGPoint(x: -5, y: -8.5), to: CGPoint(x: -15, y: -8.5), color: style.detail, width: 0.9),
      makeLine(from: CGPoint(x: 5, y: -7), to: CGPoint(x: 14, y: -4), color: style.detail, width: 0.9),
      makeLine(from: CGPoint(x: 5, y: -8.5), to: CGPoint(x: 15, y: -8.5), color: style.detail, width: 0.9),
      makeSmile(color: style.detail, y: -9)
    ].forEach {
      $0.zPosition = 3
      playerNode.addChild($0)
    }
  }

  private func addPandaParts(style: PlayerRoleStyle) {
    makeFaceDot(position: CGPoint(x: -13, y: 14), radius: 7, color: style.detail).add(to: playerNode, zPosition: -1)
    makeFaceDot(position: CGPoint(x: 13, y: 14), radius: 7, color: style.detail).add(to: playerNode, zPosition: -1)
    addGloss(style.gloss)

    let leftPatch = SKShapeNode(ellipseIn: CGRect(x: -12, y: -6, width: 10, height: 12))
    let rightPatch = SKShapeNode(ellipseIn: CGRect(x: 2, y: -6, width: 10, height: 12))
    [leftPatch, rightPatch].forEach {
      $0.fillColor = style.detail
      $0.strokeColor = .clear
      $0.zPosition = 2
      playerNode.addChild($0)
    }

    makeFaceDot(position: CGPoint(x: -7, y: -1), radius: 1.6, color: .white).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 7, y: -1), radius: 1.6, color: .white).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 0, y: -7), radius: 2.0, color: style.detail).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: -12, y: -10), radius: 2.1, color: style.blush).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 12, y: -10), radius: 2.1, color: style.blush).add(to: playerNode, zPosition: 3)
    makeSmile(color: style.detail, y: -11).add(to: playerNode, zPosition: 3)
  }

  private func addRobotParts(style: PlayerRoleStyle) {
    addGloss(style.gloss)

    makeLine(from: CGPoint(x: 0, y: 15), to: CGPoint(x: 0, y: 26), color: style.detail, width: 2).add(to: playerNode, zPosition: -1)
    makeFaceDot(position: CGPoint(x: 0, y: 29), radius: 3.2, color: style.eye).add(to: playerNode, zPosition: -1)

    let leftEye = makeRoundedNode(
      rect: CGRect(x: -11, y: -1, width: 8, height: 5),
      radius: 2.5,
      fill: style.eye,
      stroke: .clear
    )
    let rightEye = makeRoundedNode(
      rect: CGRect(x: 3, y: -1, width: 8, height: 5),
      radius: 2.5,
      fill: style.eye,
      stroke: .clear
    )
    [leftEye, rightEye].forEach {
      $0.zPosition = 3
      playerNode.addChild($0)
    }

    let mouth = makeRoundedNode(
      rect: CGRect(x: -8, y: -11, width: 16, height: 4),
      radius: 2,
      fill: style.detail,
      stroke: .clear
    )
    mouth.zPosition = 3
    playerNode.addChild(mouth)

    makeFaceDot(position: CGPoint(x: -15, y: -4), radius: 2.4, color: style.blush).add(to: playerNode, zPosition: 3)
    makeFaceDot(position: CGPoint(x: 15, y: -4), radius: 2.4, color: style.blush).add(to: playerNode, zPosition: 3)
  }

  private func makeFaceDot(position: CGPoint, radius: CGFloat, color: SKColor) -> SKShapeNode {
    let dot = SKShapeNode(circleOfRadius: radius)
    dot.position = position
    dot.fillColor = color
    dot.strokeColor = .clear
    return dot
  }

  private func makeRoundedNode(rect: CGRect, radius: CGFloat, fill: SKColor, stroke: SKColor) -> SKShapeNode {
    let node = SKShapeNode()
    node.path = CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
    node.fillColor = fill
    node.strokeColor = stroke
    node.lineWidth = stroke.cgColor.alpha == 0 ? 0 : 1.2
    return node
  }

  private func makeTriangleNode(points: [CGPoint], fill: SKColor, stroke: SKColor) -> SKShapeNode {
    let path = CGMutablePath()
    guard let first = points.first else {
      return SKShapeNode()
    }

    path.move(to: first)
    points.dropFirst().forEach {
      path.addLine(to: $0)
    }
    path.closeSubpath()

    let node = SKShapeNode(path: path)
    node.fillColor = fill
    node.strokeColor = stroke
    node.lineWidth = stroke.cgColor.alpha == 0 ? 0 : 1.2
    return node
  }

  private func makeSmile(color: SKColor, y: CGFloat) -> SKShapeNode {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: -5, y: y))
    path.addQuadCurve(to: CGPoint(x: 5, y: y), control: CGPoint(x: 0, y: y - 5))

    let node = SKShapeNode(path: path)
    node.strokeColor = color
    node.fillColor = .clear
    node.lineWidth = 1.6
    return node
  }

  private func makeLine(from: CGPoint, to: CGPoint, color: SKColor, width: CGFloat) -> SKShapeNode {
    let path = CGMutablePath()
    path.move(to: from)
    path.addLine(to: to)

    let node = SKShapeNode(path: path)
    node.strokeColor = color
    node.fillColor = .clear
    node.lineWidth = width
    return node
  }

  private func applyPlatformStyle(to platform: Platform) {
    let colorIndex = platform.paletteIndex % materials.platformPalette.count
    let fill = materials.platformPalette[colorIndex]
    let rect = CGRect(
      x: -platform.width / 2,
      y: -platform.height / 2,
      width: platform.width,
      height: platform.height
    )

    platform.node.path = CGPath(
      roundedRect: rect,
      cornerWidth: materials.platformCornerRadius,
      cornerHeight: materials.platformCornerRadius,
      transform: nil
    )
    platform.node.fillColor = fill
    platform.node.strokeColor = materials.platformStroke
    platform.node.lineWidth = materials.showsJellyDetails ? 2 : 1
    platform.node.glowWidth = materials.platformGlow
    platform.node.removeAllChildren()

    if materials.showsJellyDetails {
      let shadow = SKShapeNode(
        rectOf: CGSize(width: platform.width, height: platform.height),
        cornerRadius: materials.platformCornerRadius
      )
      shadow.fillColor = materials.platformShadow
      shadow.strokeColor = .clear
      shadow.position = CGPoint(x: 0, y: -6)
      shadow.zPosition = -1
      platform.node.addChild(shadow)
    }

    let glossHeight: CGFloat = materials.showsJellyDetails ? 12 : 8
    let cap = SKShapeNode(rectOf: CGSize(width: platform.width - 14, height: glossHeight), cornerRadius: glossHeight / 2)
    cap.fillColor = materials.platformGloss
    cap.strokeColor = .clear
    cap.position = CGPoint(x: 0, y: platform.height / 2 - 11)
    cap.zPosition = 1
    platform.node.addChild(cap)

    guard materials.showsJellyDetails else {
      return
    }

    let bubbles: [(CGFloat, CGFloat, CGFloat)] = [
      (-0.28, -7, 3.5),
      (0.12, -12, 2.6),
      (0.32, 2, 2.1)
    ]

    for bubble in bubbles {
      let node = SKShapeNode(circleOfRadius: bubble.2)
      node.position = CGPoint(x: platform.width * bubble.0, y: bubble.1)
      node.fillColor = materials.bubble
      node.strokeColor = .clear
      node.zPosition = 1
      platform.node.addChild(node)
    }
  }

  private func playLandingPulse() {
    guard materials.showsJellyDetails else {
      return
    }

    let squash = SKAction.scaleX(to: 1.12, y: 0.9, duration: 0.07)
    let stretch = SKAction.scaleX(to: 0.96, y: 1.06, duration: 0.08)
    let settle = SKAction.scale(to: 1, duration: 0.1)
    playerNode.run(SKAction.sequence([squash, stretch, settle]), withKey: "landingPulse")
  }

  private func updateLabels() {
    scoreLabel.text = "\(score)"
    bestLabel.text = "Best \(bestScore)"
  }

  private func updatePowerMeter() {
    powerTrack.fillColor = materials.powerTrack
    powerFill.fillColor = materials.powerFill

    let width = min(240, max(120, size.width - 80))
    let fillWidth = max(0, width * charge)
    powerFill.path = CGPath(
      roundedRect: CGRect(x: 0, y: -5, width: fillWidth, height: 10),
      cornerWidth: 5,
      cornerHeight: 5,
      transform: nil
    )
    powerFill.position = powerTrack.position
  }
}

private struct JumpGameView_Previews: PreviewProvider {
  static var previews: some View {
    JumpGameView()
  }
}

private extension SKNode {
  func add(to parent: SKNode, zPosition: CGFloat) {
    self.zPosition = zPosition
    parent.addChild(self)
  }
}
