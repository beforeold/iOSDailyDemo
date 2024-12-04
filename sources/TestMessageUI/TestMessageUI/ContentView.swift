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

//#Preview {
//  ContentView()
//}

struct MessageRow {
  var index: Int
  var message: Message
}

struct Message: Identifiable {
  var id = UUID()
  var name: String
  var text: String
}

struct MessageView: View {
  var list: [Message]

  var body: some View {
    VStack(spacing: 10) {
      ForEach(
        list.enumerated().map { index, message in
          MessageRow(index: index, message: message)
        }, id: \.index
      ) { row in
        HStack {
          if row.index % 2 == 0 {
            // Left side message
            HStack(alignment: .top, spacing: 10) {
              Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)

              Text(row.message.text)
                .padding(10)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(12)
                .font(.system(size: 16, weight: .regular, design: .rounded))
            }
            Spacer(minLength: 40)
          } else {
            // Right side message
            Spacer(minLength: 40)
            HStack(alignment: .top, spacing: 10) {
              Text(row.message.text)
                .padding(10)
                .background(Color.green.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(12)
                .font(.system(size: 16, weight: .regular, design: .rounded))

              Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)
            }
          }
        }
      }
    }
    .padding()
  }
}

#Preview {
  MessageView(list: [
    .init(name: "a1", text: "Hello! How are you?Just working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projects"),
    .init(name: "a2", text: "I'm good, thank you!"),
    .init(name: "a1", text: "Great to hear! What's new?"),
    .init(name: "a2", text: "Just working on some SwiftUI projects.Just working on some SwiftUI projectsJust working on some SwiftUI projects"),
    .init(name: "a1", text: "Nice! SwiftUI is fun."),
    .init(name: "a2", text: "Absolutely, enjoying it a lot!Just working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projectsJust working on some SwiftUI projects"),
  ])
}
