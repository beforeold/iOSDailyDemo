//
//  MyWidgetBundle.swift
//  MyWidget
//
//  Created by beforeold on 2022/10/20.
//

import WidgetKit
import SwiftUI

@main
struct MyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MyWidget()
        MyWidgetLiveActivity()
    }
}
