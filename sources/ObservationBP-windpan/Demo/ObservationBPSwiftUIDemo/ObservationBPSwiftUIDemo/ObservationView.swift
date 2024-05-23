//
//  ObservationView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by Brook_Mobius on 11/19/23.
//

import ObservationBP
import SwiftUI

public struct ObservationView<Content: View>: View {

  @State private var token: Int = 0

  private let content: () -> Content
  public init(
    @ViewBuilder _ content: @escaping () -> Content
  ) {
    self.content = content
  }
  
  public var body: some View {
    _ = token
    return withObservationTracking {
      content()
    } onChange: {
      token += 1
    }
  }
}

extension View {
  func toObservationView() -> some View {
    ObservationView {
      self
    }
  }
}

protocol ViewBP: View {
  associatedtype BodyBP: View
  @ViewBuilder var bodyBP: BodyBP { get }
}

extension ViewBP {
  var body: some View {
    ObservationView {
      bodyBP
    }
  }
}
