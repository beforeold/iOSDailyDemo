import SpriteKit
import SwiftUI

struct JumpGameView: View {
  @StateObject private var sceneStore = JumpGameSceneStore()

  var body: some View {
    NavigationStack {
      SpriteView(scene: sceneStore.scene)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Jump Blocks")
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
    playerNode.xScale = basePlayerScale + charge * 0.12
    playerNode.yScale = basePlayerScale - charge * 0.18
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
    backgroundColor = SKColor(red: 0.06, green: 0.065, blue: 0.075, alpha: 1)
    addChild(worldNode)
    configureHUD()
    resetGame()
  }

  private func configureHUD() {
    scoreLabel.fontSize = 30
    scoreLabel.horizontalAlignmentMode = .left
    scoreLabel.verticalAlignmentMode = .center
    scoreLabel.fontColor = .white
    addChild(scoreLabel)

    bestLabel.fontSize = 14
    bestLabel.horizontalAlignmentMode = .left
    bestLabel.verticalAlignmentMode = .center
    bestLabel.fontColor = SKColor(white: 0.68, alpha: 1)
    addChild(bestLabel)

    messageLabel.fontSize = 28
    messageLabel.horizontalAlignmentMode = .center
    messageLabel.verticalAlignmentMode = .center
    messageLabel.fontColor = .white
    addChild(messageLabel)

    powerTrack.fillColor = SKColor(white: 1, alpha: 0.16)
    powerTrack.strokeColor = .clear
    addChild(powerTrack)

    powerFill.fillColor = SKColor(red: 0.0, green: 0.56, blue: 1, alpha: 1)
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

    let first = makePlatform(centerX: 110, width: 112, color: SKColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 1))
    let second = makeNextPlatform(after: first)
    currentPlatform = first
    targetPlatform = second

    worldNode.addChild(first.node)
    worldNode.addChild(second.node)

    playerNode.fillColor = .white
    playerNode.strokeColor = SKColor(white: 0, alpha: 0.2)
    playerNode.lineWidth = 1
    playerNode.position = CGPoint(x: first.centerX, y: groundY + first.height / 2 + 24)
    playerNode.zRotation = 0
    playerNode.setScale(1)
    worldNode.addChild(playerNode)
    layoutScene()
  }

  private func makePlatform(centerX: CGFloat, width: CGFloat, color: SKColor) -> Platform {
    let height: CGFloat = 48
    let node = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 14)
    node.fillColor = color
    node.strokeColor = SKColor(white: 1, alpha: 0.12)
    node.lineWidth = 1
    node.position = CGPoint(x: centerX, y: groundY)

    let cap = SKShapeNode(rectOf: CGSize(width: width - 14, height: 8), cornerRadius: 4)
    cap.fillColor = SKColor(white: 1, alpha: 0.14)
    cap.strokeColor = .clear
    cap.position = CGPoint(x: 0, y: height / 2 - 10)
    node.addChild(cap)

    return Platform(node: node, centerX: centerX, width: width, height: height)
  }

  private func makeNextPlatform(after platform: Platform) -> Platform {
    let width = CGFloat.random(in: 86...132)
    let distance = CGFloat.random(in: 170...280)
    let centerX = platform.centerX + distance
    let palette = [
      SKColor(red: 0.04, green: 0.5, blue: 0.49, alpha: 1),
      SKColor(red: 0.0, green: 0.34, blue: 0.72, alpha: 1),
      SKColor(red: 0.95, green: 0.46, blue: 0.16, alpha: 1),
      SKColor(red: 0.2, green: 0.62, blue: 0.28, alpha: 1)
    ]

    return makePlatform(centerX: centerX, width: width, color: palette.randomElement() ?? palette[0])
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

    let rotate = SKAction.rotate(byAngle: .pi * 2, duration: duration)
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

  private func updateLabels() {
    scoreLabel.text = "\(score)"
    bestLabel.text = "Best \(bestScore)"
  }

  private func updatePowerMeter() {
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
