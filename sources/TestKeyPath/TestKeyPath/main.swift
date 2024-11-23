import Foundation


@dynamicMemberLookup
@propertyWrapper
struct Bind<Value> {
  var wrappedValue: Value

  subscript<T>(sub keyPath: WritableKeyPath<Value, T>) -> T {
    get { wrappedValue[keyPath: keyPath] }
    set { wrappedValue[keyPath: keyPath] = newValue }
  }

  subscript<T>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, T>) -> T {
    get { wrappedValue[keyPath: keyPath] }
    nonmutating set { wrappedValue[keyPath: keyPath] = newValue }
  }

  var projectedValue: Bind<Value> { self }
}

class Model {
  var name: String = ""
}

struct SomeView {
  @Bind var model = Model()

  func foo() {
    model.name = "br"
    var bind = $model
    let value = bind[sub: \Model.name]

    print(value)

    bind[sub: \.name] = "ok"
    print(bind.wrappedValue.name)

    $model.name = "be"
    let name = $model.name
    print(name)
  }
}

SomeView().foo()
