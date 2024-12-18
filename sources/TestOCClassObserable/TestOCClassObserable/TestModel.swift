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
  public var base: Base

  private let _$observationRegistrarForBase = Observation.ObservationRegistrar()

  public init(_ base: Base) {
    self.base = base
  }

  public subscript<Member>(dynamicMember keyPath: WritableKeyPath<Base, Member>) -> Member {
    get {
      accessForBase(keyPath: keyPath)
      return base[keyPath: keyPath]
    }
    set {
      accessForBase(keyPath: keyPath)
      _$observationRegistrarForBase.willSet(base, keyPath: keyPath)

      withMutationForBase(keyPath: keyPath) {
        base[keyPath: keyPath] = newValue
      }
      _$observationRegistrarForBase.didSet(base, keyPath: keyPath)
    }
  }

  internal nonisolated func accessForBase<Member>(
    keyPath: KeyPath<Base, Member>
  ) {
    _$observationRegistrarForBase.access(base, keyPath: keyPath)
  }

  internal nonisolated func withMutationForBase<Member, MutationResult>(
    keyPath: KeyPath<Base, Member>,
    _ mutation: () throws -> MutationResult
  ) rethrows -> MutationResult {
    try _$observationRegistrarForBase.withMutation(of: base, keyPath: keyPath, mutation)
  }
}
