//
//  ContentView.swift
//  TestSwiftUILongPress
//
//  Created by xipingping on 5/6/24.
//

import SwiftUI

struct LongPressGestureView: View {
  @GestureState private var isDetectingLongPress = false
  @State private var completedLongPress = false

  var longPress: some Gesture {
    LongPressGesture(minimumDuration: 1)
//      .onChanged { isPressing in
//        // self.onLongPressGesture?()
//        print("ispressing", isPressing)
//      }

          .updating($isDetectingLongPress) { currentState, gestureState,
            transaction in
            gestureState = currentState
            transaction.animation = Animation.easeIn(duration: 2.0)
          }
          .onEnded { finished in
            self.completedLongPress = finished
          }
  }


  var body: some View {
    Circle()
      .fill(self.isDetectingLongPress ? Color.red : (self.completedLongPress ? Color.green : Color.blue))
      .frame(width: 100, height: 100, alignment: .center)
//      .onTapGesture {
//        print("ontap")
//      }
      .gesture(longPress)
  }
}

struct ContentView: View {
  var body: some View {
    LongPressGestureView()
      .padding()
  }
}

#Preview {
  ContentView()
}
