import StoreKit
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
    .task {
      do {
        let verificationResult = try await AppTransaction.refresh()
        // let verificationResult = try await AppTransaction.shared

        switch verificationResult {
        case .verified(let appTransaction):
          // StoreKit verified that the user purchased this app and
          // the properties in the AppTransaction instance.
          // Add your code here.
          print("verified", appTransaction)
        case .unverified(let appTransaction, let verificationError):
          // The app transaction didn't pass StoreKit's verification.
          // Handle unverified app transaction information according
          // to your business model.
          // Add your code here.
          print("unverified", appTransaction, verificationError)
        }
      } catch {
        // Handle errors.
        print("failed", error)
      }
    }
  }
}

#Preview {
  ContentView()
}
