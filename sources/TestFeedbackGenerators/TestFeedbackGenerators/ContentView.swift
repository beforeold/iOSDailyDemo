//
//  ContentView.swift
//  TestFeedbackGenerators
//
//  Created by xipingping on 5/16/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FeedbackDemoView()
            .padding()
    }
}

import SwiftUI

struct FeedbackDemoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Feedback Generators Demo")
                .font(.largeTitle)
                .padding()

            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }) {
                Text("Success Feedback")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }) {
                Text("Warning Feedback")
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }) {
                Text("Error Feedback")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }) {
                Text("Light Impact Feedback")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            }) {
                Text("Medium Impact Feedback")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }) {
                Text("Heavy Impact Feedback")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            }) {
                Text("Selection Feedback")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct FeedbackDemoView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackDemoView()
    }
}
