//
//  ObservationView.swift
//  ObservationBP
//
//  Created by Wei Wang on 2023/08/04.
//

import Foundation
import SwiftUI

public struct ObservationView<Content: View>: View {
    
    @State private var token: Int = 0
    
    private let content: () -> Content
    public init(@ViewBuilder _ content: @escaping () -> Content) {
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

protocol ObserableView: View {
  associatedtype SomeBody: View
  @ViewBuilder var observerableBody: SomeBody { get }
}

extension ObserableView {
  var body: some View {
    ObservationView {
      observerableBody
    }
  }
}
