//
//  ContentView.swift
//  TestTCA
//
//  Created by beforeold on 2022/11/7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      MyFeatureView(store: .init(initialState: .init(),
                                 reducer: MyFeature()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
