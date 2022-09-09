//
//  ViewController.swift
//  InsetRect
//
//  Created by Brook on 2019/12/12.
//  Copyright © 2019 br. All rights reserved.
//

import UIKit

typealias Rect = UIView

class ViewController: UIViewController {
    var rects: [Rect] = {
        var rects = [Rect]()
        rects.append(UIView())
        return rects;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: view) else { return }
        
        let filtered = rects.filter { $0.frame.maxX > point.x && $0.frame.maxY > point.y }
        let sortedByMinX = filtered.sorted { $0.frame.minX < $1.frame.minX }
        let sortedByMinY = filtered.sorted { $0.frame.minY < $1.frame.minY }
        
        let minX: CGFloat
        let minY: CGFloat
        
        defer {
            let width = minX - point.x
            let height = minY - point.y
            let new = UIView(frame: CGRect(x: point.x, y: point.y, width: width, height: height))
            new.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green:  CGFloat.random(in: 0...1), blue:  CGFloat.random(in: 0...1), alpha: 1)
            view.addSubview(new)
            rects.append(new)
        }
        
        guard let xMinView = sortedByMinX.first(where: { $0.frame.minX > point.x }),
            let yMinView = sortedByMinY.first(where: { $0.frame.minY > point.y })
        else {
            print("not found");
            minX = view.frame.width
            minY = view.frame.height
            return
        }
        
        minX = xMinView.frame.minX
        minY = yMinView.frame.minY
        
       
    }
}

