import SwiftUI

struct ContentView: View {
  @State private var isPresented = false

  @Namespace var namespace

  var body: some View {
    VStack {
      Spacer()

      Text(UIDevice.current.systemVersion)

      Button {
        isPresented = true
      } label: {
        Image(systemName: "photo.badge.exclamationmark")
          .foregroundStyle(.yellow)
      }
      .matchedTransitionSource(
        id: "info",
        in: namespace
      )
      .buttonStyle(.bordered)
      //      .alert("confirm?", isPresented: $isPresented) {
      //        Button("Alert Yep", role: .destructive) {
      //
      //        }
      //      } message: {
      //        Text("message")
      //      }
      //      .confirmationDialog(
      //        "Confirm?",
      //        isPresented: $isPresented,
      //        titleVisibility: .visible,
      //      ) {
      //        Button("Confirm Yep") {
      //
      //        }
      //      } message: {
      //        Text("this can not be invoked")
      //      }
      .popover(isPresented: $isPresented) {
        VStack(alignment: .leading, spacing: 12) {
          Text("Infomation, abc rqa quoisurowr monment be happy")
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)

          Button(role: {
            if #available(iOS 26.0, *) {
              return .confirm
            } else {
              return .none
            }
          }()) {
            isPresented = false
          } label: {
            Text("Go to settings")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.bordered)
        }
//        .fixedSize(horizontal: false, vertical: false)
        // Constrain width so long text wraps inside the popover.
        .frame(maxWidth: 200, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 36)
        // Size the popover to fit its contents instead of using the default size.
//        .presentationSizing(.fitted)
        .presentationCompactAdaptation(.popover)
        .navigationTransition(
          .zoom(sourceID: "info", in: namespace)
        )
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
