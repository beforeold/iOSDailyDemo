import Shared
import SwiftUI

@main
struct iOSApp: App {
  var body: some Scene {
    WindowGroup {
      ViewWrapper()
    }
  }
}

struct MyView: View {
  // @StateObject private var viewModel: MyViewModel = .init()
  @StateObject private var viewModel = KotlinViewAdapter(
    createViewModel: { scope in IOSHelper().provdeViewModel(scope: scope) },
    getState: { viewModel in viewModel.state }
  )

  var body: some View {
    HStack(spacing: 30) {
      Button(string) {
        if viewModel.state.buttonIsLoading { return }

        viewModel.viewModel.onButtonRClicked()
      }

      Divider()

      Button("cancel") {
        viewModel.cancel()
      }
    }
    .frame(height: 100)
  }

  private var string: String {
    if viewModel.state.buttonIsLoading {
      "Loading..."
    } else {
      "Click Me"
    }
  }
}

class MyViewModel: ObservableObject {
  @Published var state: ViewState = .init(buttonIsLoading: false)

  private let helper = IOSHelper()
  private var scope: Kotlinx_coroutines_coreCoroutineScope!
  private var cancellable: CommonCancallable?
  let viewModel: ViewModel

  init() {
    scope = helper.createCoroutineScope()
    viewModel = helper.provdeViewModel(scope: scope)
    cancellable = viewModel.state.startCollect(
      onEach: { [weak self] state in
        print("get state", state?.buttonIsLoading.description ?? "null")

        guard let state, let self else { return }

        self.state = state
      },
      onCancel: {
        print("on cancel collect")
      }
    )
  }

  func cancel() {
    // helper.cancelCoroutineScope(scope: scope)
    cancellable?.cancel()
  }

  deinit {
    print("deinit begin")
    cancel()
    print("deinit end")
  }
}

struct ViewWrapper: View {
  @State private var id: Int = 0

  var body: some View {
    VStack(spacing: 30) {
      Button("reset") {
        id += 1
      }

      MyView()
        .id(id)
    }
  }
}

#Preview {
  ViewWrapper()
}

// We want to mimic StateFlow's collect method by having only a onEach lambda.
// It is async and its lifecycle is tied to the underlying coroutine
// of startCollect.
func collect<T>(
  _ stateFlow: CommonStateFlow<T>,
  onEach: @escaping (T) -> Void
) async {
  var collectionCancelled: CheckedContinuation<Void, Never>?
  let cancellable = stateFlow.startCollect(
    // Here we must still force unwrap because of Objective-C.
    onEach: { onEach($0!) },
    // In case of the coroutine cancellation, we resume the current execution
    // leading to the end of the method.
    onCancel: { collectionCancelled?.resume() }
  )
  await withTaskCancellationHandler {
    await withCheckedContinuation { continuation in
      // We store the continuation waiting either
      // for a cancellation from Kotlin that will resume it or for
      // a cancellation from Swift that will cancel this await statement.
      collectionCancelled = continuation
    }
  } onCancel: {
    // In case of Task cancellation, we take care of cancelling the Kotlin
    // job as well.
    cancellable.cancel()
  }
}

class KotlinViewAdapter<ViewModelType, StateType: AnyObject>: ObservableObject {
  let viewModel: ViewModelType
  @Published var state: StateType
  private let viewScope: Kotlinx_coroutines_coreCoroutineScope
  private var observingTask: Task<Void, Never>?

  // While going generic, we need to know how to retrieve the state from
  // the view-model. So we take a view-model factory and a state getter
  // as init params.
  init(
    createViewModel: (Kotlinx_coroutines_coreCoroutineScope) -> ViewModelType,
    getState: (ViewModelType) -> CommonStateFlow<StateType>
  ) {
    let viewScope = IOSHelper().createCoroutineScope()
    let viewModel = createViewModel(viewScope)
    let stateFlow = getState(viewModel)
    self.viewModel = viewModel
    // We initiate the state with the current value
    self.state = stateFlow.value!
    self.viewScope = viewScope
    // We start observing the CommonStateFlow
    observingTask = Task { @MainActor [weak self] in
      await collect(stateFlow) { self?.state = $0 }
    }
  }

  deinit {
    // This will cancel the underlying coroutine as well as the coroutine
    // scope of the view when the view is destroyed.
    print("native log deinit")
    cancel()
  }

  func cancel() {
    print("native log cancel")
//    observingTask?.cancel()
    IOSHelper().run()
    IOSHelper().cancelCoroutineScope(scope: viewScope)
  }
}
