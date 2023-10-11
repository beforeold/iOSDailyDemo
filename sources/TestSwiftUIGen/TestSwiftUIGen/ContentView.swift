//
//  ContentView.swift
//  TestSwiftUIGen
//
//  Created by Brook_Mobius on 10/11/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ChooseOneView()
    }
}

import SwiftUI

struct ChooseOneView: View {
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24))
                        .padding(.leading)
                    Spacer()
                    Text("Choose One")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top)
                    Spacer()
                    Image(systemName: "battery.100")
                        .font(.system(size: 24))
                        .padding(.trailing)
                }

                VStack {
                    Text("3 times free trail")
                        .font(.headline)
                        .padding()
                    Text("General similarity, just replace the face, can not use premium tuned styles")
                        .padding([.leading, .trailing])
                    Button(action: {}) {
                        Text("Free")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .padding()

                VStack {
                    Text("Pica Premium")
                        .font(.headline)
                        .padding()
                    HStack(spacing: 10) {
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                    }
                    HStack(spacing: 10) {
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                      Image(systemName: "face.smiling").frame(width: 100, height: 100).background(Color.gray)
                    }
                    Text("✓ Unlimited on premium tuned styles")
                        .padding(.top)
                    Text("✓ Replace any face from uploaded")
                    Text("✓ Higher similarity: Need more photos to generate your AI twin")
                        .padding(.bottom)
                    Button(action: {}) {
                        Text("Popular")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.bottom)
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
                .padding()

                Spacer()

                Button(action: {}) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding([.leading, .trailing, .bottom])
            }
            .background(Color.gray.opacity(0.1))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//struct ChooseOneView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseOneView()
//    }
//}
