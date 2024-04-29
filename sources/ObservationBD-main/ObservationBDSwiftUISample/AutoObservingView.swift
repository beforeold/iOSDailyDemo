//
//  AutoObservingView.swift
//  ObservationBDSwiftUISample
//
//  Created by Dmitry Galimzyanov on 03.07.2023.
//

import Combine
import ObservationBD
import SwiftUI

struct AutoObservingView<Content: View>: View {
  private let invalidator: Invalidator
  private let content: () -> Content

  @State var token = 0
  
  init(@ViewBuilder content: @escaping () -> Content) {
    let invalidator = Invalidator()
    self.invalidator = invalidator
    self.content = content
  }

  var body: Content {
    withObservationTrackingBD {
      content()
    } onChange: {
      Task {
        await invalidator.invalidate()
      }
//      token += 1
    }
  }
}

protocol ObserableView: View {
  associatedtype NewBody: View
  @ViewBuilder var observerableBody: NewBody { get }
}

extension ObserableView {
  var body: some View {
    AutoObservingView {
      observerableBody
    }
  }
}

struct Invalidator: DynamicProperty {
  final class Emitter: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
  }

  @ObservedObject private var emitter = Emitter()

  func invalidate() {
    emitter.objectWillChange.send()
  }
}
