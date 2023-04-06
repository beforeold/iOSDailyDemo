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
    print(#function)
    updatePlusAge(person: person)
  }
  
  private func updateResetPersons() {
    var persons = self.persons
    persons[0] = persons[0]
    self.persons = persons
  }
  
  private func updatePlusAge(person: Person) {
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
    print(#function)
    return content
  }
  
  var content: some View {
    List(persons) { person in
      VStack(alignment: .leading) {
        Text("Age: \(person.age)")
        Text("ID: \(person.id)")
          .foregroundColor(.gray)
      }
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
