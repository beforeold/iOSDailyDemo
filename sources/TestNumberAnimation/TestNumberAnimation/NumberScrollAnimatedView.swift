//
//  NumberScrollAnimatedView.swift
//  TestNumberAnimation
//
//  Created by Brook_Mobius on 5/26/23.
//

import UIKit


/// NumberScrollAnimatedView
///
/// see https://github.com/AlexSmet/NumberScrollAnimatedView
public class NumberScrollAnimatedView: UIView {
    /// Displayable value, numeric symbols will display with scroll animation
    public var text: String = ""

    public var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    public var textColor: UIColor = .black
    /// Animation duration
    public var animationDuration: CFTimeInterval = 5

    /**
     Custom rule specifies the offset of the animation start time for each numerical symbol.
     By default the rule return random values from 0 to 1.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation time offset for each symbol.
    */
    public var animationTimeOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    /**
     Custom rule specifies the change in animation duration for each numerical symbol.
     By default the rule return random values from 0 to 1.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation duration time offset for each symbol.
    */
    public var animationDurationOffsetRule: ((_ text: String, _ index: Int) -> CFTimeInterval)!
    /**
     Custom rule specifies the animation direction (UP or DOWN) for each numerical symbol.
     By default the rule return random values.

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return an animation direction for each symbol.
    */
    public var scrollingDirectionRule: ((_ text: String, _ index: Int) -> NumberScrollAnimationDirection)!
    /**
     Custom rule specifies whether to invert the sequence of numbers or not.
     By default is 0123456789, with inversion 9876543210

     Parameters:

     **text**: displayable text

     **index**: symbol's index for which the rule will be applied

     Return bool-value
    */
    public var inverseSequenceRule: ((_ scrollableValue: String, _ forColumn: Int) -> Bool)!

    private var scrollableColumns: [NumberScrollableColumn] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        animationTimeOffsetRule = NumberScrollAnimatedView.random
        animationDurationOffsetRule = NumberScrollAnimatedView.random
        scrollingDirectionRule = NumberScrollAnimatedView.random
        inverseSequenceRule = NumberScrollAnimatedView.random
    }

    public func startAnimation() {
        prepareAnimation()
        createAnimations()
    }

    private func prepareAnimation() {
        scrollableColumns.forEach { $0.removeFromSuperlayer() }
        scrollableColumns.removeAll()

        createScrollColumns()
    }

    public func stopAnimation() {
        scrollableColumns.forEach { $0.removeAllAnimations() }
    }

    fileprivate func createScrollColumns() {
        let height: CGFloat = frame.height

        let numericSymbolWidth = String.numericSymbolsMaxWidth(usingFont: font)
        var width: CGFloat
        var xPosition: CGFloat = 0
        for character in text {
            if let _ = Int(String(character)) {
                width = numericSymbolWidth
            } else {
                width = String(character).width(usingFont: font)
            }

            let newColumnFrame = CGRect(x: xPosition , y: 0, width: width, height: height)
            let newColumn = NumberScrollableColumn(withFrame: newColumnFrame, forLayer: layer, font: font, textColor: textColor)
            newColumn.symbol = character
            scrollableColumns.append(newColumn)

            xPosition += width
        }

        let xOffset = (layer.bounds.width - xPosition) / 2.0
        scrollableColumns.forEach { $0.scrollLayer.position.x += xOffset }
    }

    fileprivate func createAnimations() {
        for (index, column) in scrollableColumns.enumerated() {
            column.createAnimation(
                timeOffset: animationTimeOffsetRule(text, index),
                duration: animationDuration,
                durationOffset: animationDurationOffsetRule(text, index),
                scrollingDirection: scrollingDirectionRule(text, index),
                inverseSequence: inverseSequenceRule(text, index))
        }
    }
}


@nonobjc extension NumberScrollAnimatedView {
    static func random(_ scrollableValue: String, _ forColumn: Int) -> CFTimeInterval {
        return drand48()
    }

    static func random(_ scrollableValue: String, _ forColumn: Int) -> Bool {
        let randomValue = arc4random_uniform(2)
        if  randomValue == 0 {
            return true
        } else {
            return false
        }
    }

    static func random(_ scrollableValue: String, _ forColumn: Int) -> NumberScrollAnimationDirection {
        if arc4random_uniform(2) == 0 {
            return .down
        } else {
            return .up
        }
    }
}


private extension String {
    func size(usingFont font: UIFont) -> CGSize {
        #if swift(>=4.2)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        #elseif swift(>=4)
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        #else
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        #endif
        
        return size
    }

    func width(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).width
    }

    func height(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).height
    }

    static func numericSymbolsMaxWidth(usingFont font: UIFont) -> CGFloat {
        var maxWidth:CGFloat = 0

        for symbol in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] {
            maxWidth = Swift.max(maxWidth, symbol.width(usingFont: font))
        }

        return maxWidth
    }
}
public enum NumberScrollAnimationDirection {
    case up
    case down
}

class NumberScrollableColumn {
    private var font: UIFont
    private var textColor: UIColor

    var symbol: Character!

    var timeOffset: CFTimeInterval = 0
    var duration: CFTimeInterval = 5
    var durationOffset: CFTimeInterval = 0
    var scrollingDirection: NumberScrollAnimationDirection = .down
    var inverseSequence: Bool = false

    var scrollLayer: CAScrollLayer

    init(withFrame frame: CGRect, forLayer superLayer: CALayer, font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor

        scrollLayer = CAScrollLayer()
        scrollLayer.frame = frame
        superLayer.addSublayer(scrollLayer)
    }

    func createAnimation(timeOffset: CFTimeInterval, duration: CFTimeInterval, durationOffset: CFTimeInterval, scrollingDirection: NumberScrollAnimationDirection, inverseSequence: Bool = false) {
        self.timeOffset = timeOffset
        self.duration = duration
        self.durationOffset = durationOffset
        self.scrollingDirection = scrollingDirection
        self.inverseSequence = inverseSequence

        if let _ = Int(String(symbol)) {
            createContent(numericalSymbol: symbol)
            addBeginAnimation()
            addMainAnimation()
        } else {
            createContent(nonNumericalSymbol: symbol)
        }
    }

    private func addBeginAnimation() {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = timeOffset
        animation.fromValue = getStartPositionYForAnimation()
        animation.toValue = (animation.fromValue as! CGFloat)
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        scrollLayer.add(animation, forKey: nil)
    }

    private func addMainAnimation() {
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.beginTime = CACurrentMediaTime() + timeOffset
        animation.duration = duration - timeOffset - durationOffset
        animation.fromValue = getStartPositionYForAnimation()
        animation.toValue = 0
        #if swift(>=4.2)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        #else
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        #endif
        
        scrollLayer.add(animation, forKey: nil)
    }

    private func getStartPositionYForAnimation() -> CGFloat {
        var result: CGFloat

        let startOffsetY =  scrollLayer.frame.height
        switch scrollingDirection {
        case .down:
            let maxY: CGFloat = (scrollLayer.sublayers?.last?.frame.origin.y)!
            result  = -maxY - startOffsetY
        case .up:
            let minY: CGFloat = (scrollLayer.sublayers?.first?.frame.origin.y)!
            result = -minY + startOffsetY
        }

        return result
    }

    func removeAllAnimations() {
        scrollLayer.removeAllAnimations()
    }

    func removeFromSuperlayer() {
        scrollLayer.removeFromSuperlayer()
    }

    private func createContent(nonNumericalSymbol: Character) {
        let textLayer = createTextLayer(withText: String(nonNumericalSymbol))
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.frame = CGRect(x: 0, y: 0, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
        scrollLayer.addSublayer(textLayer)
    }

    private func createContent(numericalSymbol: Character) {
        let number = Int(String(numericalSymbol))!
        var textForScroll = [String]()

        var firstNumber: Int
        var lastNumber: Int
        var by: Int = 1

        // Scrolling starts from 0, by default. But when a target value is 0, than we can start scrolling from 1 or 9 (depends on the values of scrollingDirection and inverseSequence)
        switch scrollingDirection {
        case .up:
            lastNumber = number
            if inverseSequence {
                by = -1
                firstNumber = 10
                if number == 0 {
                    firstNumber = 9
                }
            } else {
                firstNumber = 0
                if number == 0 {
                    firstNumber = 1
                    lastNumber = 10
                }
            }
        case .down:
            firstNumber = number
            if inverseSequence {
                by = -1
                lastNumber = 0
                if number == 0 {
                    firstNumber = 10
                    lastNumber = 1
                }

            } else {
                lastNumber = 10
                if number == 0 {
                    lastNumber = 9
                }
            }
        }

        for i in stride(from: firstNumber, through: lastNumber, by: by) {
            textForScroll.append("\(i%10)")
        }

        var height: CGFloat = 0
        scrollLayer.sublayers?.removeAll()

        switch scrollingDirection {
        case .down:
            height = 0
        case .up:
            height = -scrollLayer.frame.height * CGFloat(textForScroll.count-1)
        }

        textForScroll.forEach {
            let textLayer = createTextLayer(withText: $0)
            textLayer.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
            scrollLayer.addSublayer(textLayer)
            height += scrollLayer.frame.height
        }
    }

    private func createTextLayer(withText: String) -> VerticallyCenteredTextLayer {
        let newLayer = VerticallyCenteredTextLayer()
        newLayer.contentsScale = UIScreen.main.scale
        
        #if swift(>=4.2)
        let attributedString = NSAttributedString( string: withText, attributes: [ NSAttributedString.Key.foregroundColor: textColor.cgColor, NSAttributedString.Key.font: font])
        newLayer.alignmentMode = CATextLayerAlignmentMode.center
        #elseif swift(>=4)
        let attributedString = NSAttributedString( string: withText, attributes: [ NSAttributedStringKey.foregroundColor: textColor.cgColor, NSAttributedStringKey.font: font])
        newLayer.alignmentMode = kCAAlignmentCenter
        #else
        let attributedString = NSAttributedString( string: withText, attributes: [ NSForegroundColorAttributeName: textColor.cgColor, NSFontAttributeName: font])
        newLayer.alignmentMode = kCAAlignmentCenter
        #endif
        
        newLayer.string = attributedString
        
        return newLayer
    }
}


private class VerticallyCenteredTextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        if let attributedString = self.string as? NSAttributedString {
            let height = self.bounds.size.height
            let stringSize = attributedString.size()
            let yDiff = (height - stringSize.height) / 2

            ctx.saveGState()
            ctx.translateBy(x: 0.0, y: yDiff)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
}
