//
//  main.swift
//  TestFunctionHighlight
//
//  Created by xipingping on 5/13/24.
//

import Foundation


struct Builder {
  func build(
    arg1: String = "",
    block1: () -> Void,
    block2: () -> Void
  ) {
    block1()
    block2()
  }
}

func build(
  arg1: String = "",
  block1: () -> Void,
  block2: () -> Void
) {
  block1()
  block2()
}

func foo() {
  build(arg1: "1") {
    print("block1")
  } block2: {
    print("block2")
  }

  build(
    arg1: "",
    block1: { print("") },
    block2: { print("block2") }
  )

  Builder().build(arg1: "") {
    print("")
  } block2: {
    print("")
  }

  Builder().build(
    arg1: "",
    block1: { print("") },
    block2: { print("block2") }
  )
}


