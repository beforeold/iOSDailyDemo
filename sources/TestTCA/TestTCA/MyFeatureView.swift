//
//  MyFeatureView.swift
//  TestTCA
//
//  Created by Brook_Mobius on 2022/11/8.
//

import SwiftUI
import ComposableArchitecture


struct MyFeatureView: View {
  typealias Feature = MyFeature
  
  let store: StoreOf<Feature>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Button("−") { viewStore.send(.decrementButtonTapped) }
          Text("\(viewStore.count)")
          Button("+") { viewStore.send(.incrementButtonTapped) }
        }
        Button("Number fact") { viewStore.send(.numberFactButtonTapped) }
      }
      .alert(
        item: viewStore.binding(
          get: { $0.numberFactAlert.map(FactAlert.init(title:)) },
          send: .factAlertDismissed
        ),
        content: { Alert(title: Text($0.title)) }
      )
    }
  }
}

struct FactAlert: Identifiable {
  var title: String
  var id: String { self.title }
}

struct MyFeatureView_Previews: PreviewProvider {
  static var previews: some View {
    MyFeatureView(store: Store(initialState: .init(),
                               reducer: MyFeature()))
  }
}
