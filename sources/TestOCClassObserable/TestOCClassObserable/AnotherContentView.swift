import SwiftData
import SwiftUI

@Observable
class TestModel {
  var name = ""
}

@Model
class DataModel {
  var name = ""

  init(name: String = "") {
    self.name = name
  }
}

@Observable
class NewPerson {
  var name: String = ""
  var age = 0
  var isPresented = false

  init(myPerson: MYPerson) {
    self.name = myPerson.name ?? ""
    self.age = myPerson.age
    self.isPresented = myPerson.isPresented
  }
}

@Observable
class SwiftPerson {
  var person: MYPerson = .init()

  func update(name: String) {
    let newPerson = MYPerson()
    newPerson.age = person.age
    newPerson.name = name
    newPerson.isPresented = person.isPresented

    person = newPerson
  }
}

@Observable
class ParentModel {
  var model = OCObservable<MYPerson>(wrappedValue: .init())

  func foo() {
    model = .init(wrappedValue: .init())
    // model.wrappedValue = .init()
  }
}

struct AnotherContentView: View {
  //  @Query var models: [DataModel]

  @State private var age: Int = 5

  //  @State @OCObservable var model2 = MYPerson()
  //  @OCObservable var model = MYPerson()
    @State var model = OCObservable(wrappedValue: MYPerson())
//  var model = OCObservable(wrappedValue: MYPerson())
  // var _model = OCObservable(wrappedValue: MYPerson())
  // private var __model = State(wrappedValue: OCObservable(wrappedValue: MYPerson()))
  //  @OCObservable2 var model: OCObservable<MYPerson>

  var body: some View {
//    @Bindable var model = model

    let _ = Self._printChanges()

    VStack(spacing: 30) {
      Text("name: \(self.model.name ?? "null")")

      Button("Change Name") {
        withAnimation {
          let cur = model.name ?? ""
          // model.name = cur + "go_"
          model.wrappedValue.updateName(cur + "go_")
        }
      }

      SubView(model: self.model)

      Button("show detail") {
        model.isPresented = true
      }

      Button("Change Person") {
        let person = MYPerson()
        person.name = "new person"
        person.age = 666
        model.wrappedValue = person
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
    .sheet(isPresented: $model.isPresented) {
      Text("Person detail")
    }
  }
}

struct SubView: View {
  var model: OCObservable<MYPerson>

  var body: some View {
    let _ = Self._printChanges()

    VStack {
      Text("age: \(model.age)")

      Button("plus age") {
        model.age += 1
      }
    }
  }
}


#Preview {
  AnotherContentView()
}
