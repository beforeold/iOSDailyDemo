import Foundation
import Observation

@Observable
class TestModel {
  var name = ""
}

@Observable
@dynamicMemberLookup
class OtherModel<Base> {
  @ObservationIgnored
  var base: Base

  init(base: Base) {
    self.base = base
  }

  @ObservationIgnored private let _$observationRegistrar = Observation.ObservationRegistrar()

  subscript<Member>(dynamicMember keyPath: WritableKeyPath<Base, Member>) -> Member {
    get {
      access(keyPath: keyPath)
      return base[keyPath: keyPath]
    }
    set {
        withMutation(keyPath: keyPath) {
          base[keyPath: keyPath] = newValue
        }
    }
    _modify {
      access(keyPath: keyPath)
      _$observationRegistrar.willSet(self, keyPath: \.base.append(keyPath))
        defer {
          _$observationRegistrar.didSet(self, keyPath: \.age)
        }
//        yield &_age
    }
  }

//  private var age = 0

  internal nonisolated func access<Member>(
      keyPath: KeyPath<Base, Member>
  ) {
//    _$observationRegistrar.access(self, keyPath: \.age)
  }

  internal nonisolated func withMutation<Member, MutationResult>(
      keyPath: KeyPath<Base, Member>,
      _ mutation: () throws -> MutationResult
  ) rethrows -> MutationResult {
//    try _$observationRegistrar.withMutation(of: self, keyPath: \.age, mutation)
  }
}
