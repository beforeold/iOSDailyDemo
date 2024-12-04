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

//import VisionOS

struct MessageRow {
    var index: Int
    var message: Message
}

struct Message: Identifiable {
    var id = UUID()
    var name: String
    var text: String
}

import RealityKit
import ARKit

struct MessageView: View {
    var list: [Message]

    var body: some View {
      ImmersiveSpace {
            VStack(spacing: 30) {
                ForEach(
                    list.enumerated().map { index, message in
                        MessageRow(index: index, message: message)
                    }, id: \.index
                ) { row in
                    ZStack {
                        if row.index % 2 == 0 {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.blue)
                                    .shadow(radius: 5)

                                Text(row.message.text)
                                    .padding(15)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 5)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                            }
                            .transformEffect(CGAffineTransform(translationX: -10, y: 0))
                        } else {
                            HStack(alignment: .top, spacing: 10) {
                                Text(row.message.text)
                                    .padding(15)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 5)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
                                    .transformEffect(CGAffineTransform(translationX: 10, y: 0))

                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(.green)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .rotation3DEffect(
                        .degrees(row.index % 2 == 0 ? 10 : -10),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .zIndex(Double(row.index))
                }
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [.black.opacity(0.8), .blue.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(20)
            .shadow(radius: 20)
        }
//        .toolbar {
//            ImmersiveToolbar {
//                Button(action: {
//                    print("Exiting immersive mode...")
//                }) {
//                    Label("Exit", systemImage: "xmark.circle")
//                }
//            }
//        }
    }
}

//#Preview {
//  ContentView()
//}

#Preview {
    MessageView(list: [
        .init(name: "a1", text: "Hello! How are you?"),
        .init(name: "a2", text: "I'm good, thank you!"),
        .init(name: "a1", text: "Great to hear! What's new?"),
        .init(name: "a2", text: "Just working on some VisionOS projects."),
        .init(name: "a1", text: "Nice! VisionOS is interesting."),
        .init(name: "a2", text: "Absolutely, so much potential!"),
    ])
}
