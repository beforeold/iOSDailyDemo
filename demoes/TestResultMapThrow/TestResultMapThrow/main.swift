//
//  main.swift
//  TestResultMapThrow
//
//  Created by BrookXy on 2022/1/20.
//

import Foundation

var ret = Result<Void, Error>.success(())

func fail(_ arg: Void) throws -> Int  {
    return 5
}

let ret2: Result<Int, Error> = ret.flatMap {
    do {
        let int = try fail($0)
        return .success(int)
    } catch {
        return .failure(error)
    }
}

let ret3: Result<Void, Error> = ret.flatMapError { error in
    return .failure(error)
}
