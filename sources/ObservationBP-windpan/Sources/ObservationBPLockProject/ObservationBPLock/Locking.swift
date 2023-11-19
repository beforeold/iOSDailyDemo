//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

@_silgen_name("_swift_observation_lock_size")
func _lockSize() -> Int

@_silgen_name("_swift_observation_lock_init")
func _lockInit(_: UnsafeRawPointer)

@_silgen_name("_swift_observation_lock_lock")
func _lockLock(_: UnsafeRawPointer)

@_silgen_name("_swift_observation_lock_unlock")
func _lockUnlock(_: UnsafeRawPointer)

public struct _ManagedCriticalState<State> {
  private final class LockedBuffer: ManagedBuffer<State, UnsafeRawPointer> {}

  private let buffer: ManagedBuffer<State, UnsafeRawPointer>

  public init(_ buffer: ManagedBuffer<State, UnsafeRawPointer>) {
    self.buffer = buffer
  }

  public init(_ initial: State) {
    let roundedSize = (_lockSize() + MemoryLayout<UnsafeRawPointer>.size - 1) / MemoryLayout<UnsafeRawPointer>.size
    self.init(LockedBuffer.create(minimumCapacity: Swift.max(roundedSize, 1)) { buffer in
      buffer.withUnsafeMutablePointerToElements { _lockInit(UnsafeRawPointer($0)) }
      return initial
    })
  }

  public func withCriticalRegion<R>(
    _ critical: (inout State) throws -> R
  ) rethrows -> R {
    try buffer.withUnsafeMutablePointers { header, lock in
      _lockLock(UnsafeRawPointer(lock))
      defer {
        _lockUnlock(UnsafeRawPointer(lock))
      }
      return try critical(&header.pointee)
    }
  }
}

extension _ManagedCriticalState: @unchecked Sendable where State: Sendable {}

extension _ManagedCriticalState: Identifiable {
  public var id: ObjectIdentifier {
    ObjectIdentifier(buffer)
  }
}
