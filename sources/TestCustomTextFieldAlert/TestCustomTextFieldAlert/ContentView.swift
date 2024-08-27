import SwiftUI

import SwiftUI

struct TextFieldAlertModifier: ViewModifier {
  @Binding var isPresented: Bool
  @Binding var text: String
  var title: String
  var confirmAction: () -> Void

  func body(content: Content) -> some View {
    ZStack {
      content

      if isPresented {
        Color.black.opacity(0.4)
          .ignoresSafeArea()

        VStack(spacing: 20) {
          Text(title)
            .font(.headline)

          TextField("Enter here...", text: $text)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)

          HStack(spacing: 20) {
            Button("Cancel") {
              isPresented = false
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            .foregroundColor(.white)

            Button("Confirm") {
              isPresented = false
              confirmAction()
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .foregroundColor(.white)
          }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding(.horizontal, 40)
      }
    }
  }
}

extension View {
  public func textFieldAlert(
    isPresented: Binding<Bool>,
    text: Binding<String>,
    title: String,
    confirmAction: @escaping () -> Void
  ) -> some View {
    self.modifier(TextFieldAlertModifier(isPresented: isPresented, text: text, title: title, confirmAction: confirmAction))
  }
}

struct ContentView: View {
  @State private var showAlert = false
  @State private var inputText = ""

  var body: some View {
    VStack {
      Button("Show Alert") {
        showAlert = true
      }
    }
    .textFieldAlert(isPresented: $showAlert, text: $inputText, title: "Enter Your Name") {
      print("User input: \(inputText)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
