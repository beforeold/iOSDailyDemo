//
//  ContentView.swift
//  TestAlertView
//
//  Created by xipingping on 7/11/24.
//

import SwiftUI

struct SubscriptionAlertView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("Subscription & Credits")
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            VStack(alignment: .leading, spacing: 8) {
                Text("• Credits can only be used within the subscription period.")
                Text("• Additional credits valid for 90 days can be purchased anytime.")
                Text("• The same amount of credits will be earned with each renewal.")
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
            Button(action: {
                // Handle button action
            }) {
                Text("Got it")
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.blue)
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color(white: 0.9))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

struct ContentView: View {
    var body: some View {
        SubscriptionAlertView()
            .padding()
            .background(Color(UIColor.systemBackground)) // Ensure proper background color
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
  ContentView()
    .preferredColorScheme(.light)
}
