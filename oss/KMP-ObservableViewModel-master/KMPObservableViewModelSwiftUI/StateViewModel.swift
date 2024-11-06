//
//  StateViewModel.swift
//  KMPObservableViewModelSwiftUI
//
//  Created by Rick Clephas on 27/11/2022.
//

import SwiftUI
import KMPObservableViewModelCore
import KMPObservableViewModelCoreObjC

/// A `StateObject` property wrapper for `ViewModel`s.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@propertyWrapper
public struct StateViewModel<VM: ViewModel>: DynamicProperty {
    
    @StateObject private var observableObject: ObservableViewModel<VM>
    
    /// The underlying `ViewModel` referenced by the `StateViewModel`.
    public var wrappedValue: VM { observableObject.viewModel }
    
    /// A projection of the observed `ViewModel` that creates bindings to its properties using dynamic member lookup.
    public var projectedValue: ObservableViewModel<VM>.Projection {
        ObservableViewModel.Projection(observableObject)
    }
    
    /// Creates a `StateViewModel` for the specified `ViewModel`.
    /// - Parameter wrappedValue: The `ViewModel` to observe.
    public init(wrappedValue: @autoclosure @escaping () -> VM) {
        self._observableObject = StateObject(wrappedValue: observableViewModel(for: wrappedValue()))
    }
}


#if DEBUG
import SwiftUI

class MyViewModelScope: ViewModelScope {
  func increaseSubscriptionCount() {

  }
  
  func decreaseSubscriptionCount() {

  }
  
  func setSendObjectWillChange(_ sendObjectWillChange: @escaping () -> Void) {

  }


  deinit {
    print(#function, self)
  }
}

class MyViewModel: ViewModel {
  var viewModelScope: any ViewModelScope

  func clear() {

  }

  deinit {
    print(#function, self)
  }

  @Published var name: String

  init(viewModelScope: MyViewModelScope, name: String) {
    self.viewModelScope = viewModelScope
    self.name = name
  }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct SomeView: View {
  @StateViewModel
  private var viewModel: MyViewModel = .init(viewModelScope: .init(), name: "initial")

  var body: some View {
    Text(viewModel.name)
      .onTapGesture {
        viewModel.name = "changed"
      }
  }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct ToggleView: View {
  @State private var id: Int = 0

  var body: some View {
    VStack(spacing: 30) {
      SomeView()
        .id(id)

      Button("Reset") {
        id += 1
      }
    }
  }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
#Preview {
  ToggleView()
}
#endif
