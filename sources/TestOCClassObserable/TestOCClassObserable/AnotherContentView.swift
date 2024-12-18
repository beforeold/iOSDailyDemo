import SwiftUI

@Observable
class ParentModel {
  var model = OCObservable<MYPerson>(wrappedValue: .init())

  func foo() {
    model = .init(wrappedValue: .init())
    // model.wrappedValue = .init()
  }
}

struct AnotherContentView: View {
  @State var model = OCObservable(wrappedValue: MYPerson())

  var body: some View {
    @Bindable var model = model
    let _ = Self._printChanges()

    VStack(spacing: 30) {
      Text("name: \(model.name ?? "null")")

      Button("Change Name") {
        withAnimation {
          let cur = model.name ?? ""
          model.name = cur + "go_"
        }
      }

      SubView(model: model)

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
