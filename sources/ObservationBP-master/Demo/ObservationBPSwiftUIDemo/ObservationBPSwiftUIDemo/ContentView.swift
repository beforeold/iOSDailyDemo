//
//  ContentView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by Wei Wang on 2023/08/04.
//

import SwiftUI
import ObservationBP

@Observable final class Person {
  var name: String
  var age: Int

  var isReady: Bool = false
  var readyCount: Int = 0

  init(name: String, age: Int) {
    self.name = name
    self.age = age
  }
}

struct ContentView: View {

  private var person = Person(name: "Tom", age: 12)

  var body: some View {
    ObservationView {
      VStack {
        Text(person.name)
        Text("\(person.age)")

        if person.isReady {
          Button("To Not Ready") {
            person.isReady = false
            person.readyCount += 1
          }
          Text(person.readyCount.description)
        } else {
          Button("To Ready") {
            person.isReady = true
            person.readyCount += 1
          }
          Text(person.readyCount.description)
        }

        HStack {
          Button("+") { person.age += 1 }
          Button("-") { person.age -= 1 }
        }
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}

//
//@Observable class Object {
//  var name = "beforeold"
//}
//
//private struct TestView: ViewBP {
//  let object = Object()
//
//  var bodyBP: some View {
//    Text("Hello \(object.name)")
//
//    Button("rename") {
//      object.name = "other name"
//    }
//  }
//}
