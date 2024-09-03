import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

func highlightExpectation() {
  withContext {
    //
  } onSuccess: {
    //
  } onFailed: {
    //
  }

  withContext(
    action: {
      //
    },
    onSuccess: {
      //
    },
    onFailed: {
      //
    }
  )

  Wrap.withContext {

  } onSuccess: {

  } onFailed: {

  }

  Wrap.withContext(
    action: {
      //
    },
    onSuccess: {
      //
    },
    onFailed: {
      //
    }
  )
}

struct Wrap {
  static func withContext(
    action: () -> Void,
    onSuccess: () -> Void,
    onFailed: () -> Void
  ) {

  }
}


func withContext(
  action: () -> Void,
  onSuccess: () -> Void,
  onFailed: () -> Void
) {

}

#Preview {
  ContentView()
}
