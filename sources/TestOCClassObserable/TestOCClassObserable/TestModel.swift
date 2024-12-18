import Foundation
import Observation

@Observable
class TestModel {
  var name = ""
}

extension NSObject: @retroactive Observable {

}

@Observable
@dynamicMemberLookup
class OCObservable<Base: Observable> {
  public var wrappedValue: Base

  private let _$observationRegistrarForBase = Observation.ObservationRegistrar()

  public init(wrappedValue: Base) {
    self.wrappedValue = wrappedValue
  }

  public subscript<Member>(dynamicMember keyPath: ReferenceWritableKeyPath<Base, Member>) -> Member {
    get {
      accessForBase(keyPath: keyPath)
      return wrappedValue[keyPath: keyPath]
    }
    set {
      accessForBase(keyPath: keyPath)
      _$observationRegistrarForBase.willSet(wrappedValue, keyPath: keyPath)

      withMutationForBase(keyPath: keyPath) {
        wrappedValue[keyPath: keyPath] = newValue
      }
      _$observationRegistrarForBase.didSet(wrappedValue, keyPath: keyPath)
    }
  }

  internal nonisolated func accessForBase<Member>(
    keyPath: KeyPath<Base, Member>
  ) {
    _$observationRegistrarForBase.access(wrappedValue, keyPath: keyPath)
  }

  internal nonisolated func withMutationForBase<Member, MutationResult>(
    keyPath: KeyPath<Base, Member>,
    _ mutation: () throws -> MutationResult
  ) rethrows -> MutationResult {
    try _$observationRegistrarForBase.withMutation(of: wrappedValue, keyPath: keyPath, mutation)
  }
}
