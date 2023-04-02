//
//  ContentView.swift
//  TestSwiftUIIdentifiable
//
//  Created by Brook_Mobius on 2023/4/2.
//

import SwiftUI

struct Person: Identifiable {
  let id: UUID = .init()
  
  var age: Int = 0
}

struct ContentView: View {
  
  @State var persons: [Person] = [
    .init(),
    .init(),
    .init(),
    .init(),
  ]
  
  private func update(person: Person) {
//     self.persons = persons
//     self.persons[0].age += 10
//    return
    
    guard let index = persons.firstIndex(where: { p in
      p.id == person.id
    }) else {
      return
    }
    
    var person = self.persons[index]
    person.age += 10
    
    withAnimation {
      self.persons[index] = person
    }
  }
  
  var body: some View {
    return content
  }
  
  var content: some View {
    List(persons) { person in
      Text("age: \(person.id)")
        .onTapGesture {
          self.update(person: person)
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
