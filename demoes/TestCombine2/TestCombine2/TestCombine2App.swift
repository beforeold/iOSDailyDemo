//
//  TestCombine2App.swift
//  TestCombine2
//
//  Created by dinglan on 2021/5/7.
//

import SwiftUI
import Foundation
import Combine




@main
struct TestCombine2App: App {
    
    
    var body: some Scene {
        let g = WindowGroup {
            ContentView()
        }
        
        //        fc()
        
//        createTryMap2().globalSub()
        bar()
        
        return g
    }
}

class Global {
    static var publisher: Any?
    static var cancel: Any?
}


func fa() {
    let publisher = PassthroughSubject<Int, Never>()
    
    
    publisher.send(1)
    publisher.send(2)
    publisher.send(completion: .finished)
    
    publisher.globalSub()
    
    publisher.send(3)
    publisher.send(completion: .finished)
}


extension Publisher {
    func globalSub() {
        Swift.print("开始订阅")
        let publisher = self
        let cancel = publisher.sink(
            receiveCompletion: { complete in
                Swift.print(complete)
            },
            receiveValue: { value in
                Swift.print(value)
            }
        )
        
        Global.publisher = publisher
        Global.cancel = cancel
    }
}

func fb() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    publisher.value = 1
    publisher.value = 2
    publisher.send(completion: .finished)
    
    publisher.globalSub()
}

func fc() {
    let publisher = CurrentValueSubject<Int, Never>(0)
    
    publisher.globalSub()
    
    publisher.value = 1
    publisher.value = 2
    publisher.send(3)
    publisher.send(completion: .finished)
    print("--- \(publisher.value) ---")
}

//fa()
//fb()
//fc()

struct ParseError: Error {
    
}

func romanNumeral(from: Int) throws -> String {
    let romanNumeralDict: [Int : String] =
        [1:"I", 2:"II", 3:"III", 4:"IV", 5:"V"]
    guard let numeral = romanNumeralDict[from] else {
        throw ParseError()
    }
    return numeral
}


let numbers = [5, 4, 3, 2, 1, 0]

func createTryMap2() -> some Publisher {
    let pub1 = numbers.publisher
    let pub2 = pub1.tryMap { try romanNumeral(from: $0) }
    return pub2
}



class LoadingUI {
    var isSuccess: Bool = false
    var text: String = ""
}

struct Response: Decodable {
    struct Foo: Decodable {
        let foo: String
    }
    let args: Foo?
}

func bar() {
    let dataTaskPublisher = URLSession.shared
        .dataTaskPublisher(
            for: URL(string: "http://httpbin.org/get?foo=bar")!)
        .share()
    
//    let isSuccess = dataTaskPublisher
//        .map { data, response -> Bool in
//            guard let httpRes = response as? HTTPURLResponse else {
//                return false
//            }
//            return httpRes.statusCode == 200
//        }
//        .replaceError(with: false)
//    Global.cancel = isSuccess.sink { completion in
//        print(completion)
//    } receiveValue: { ret in
//        print(ret)
//    }

    
    let latestText = dataTaskPublisher
        .map { data, _ in data }
        .decode(type: Response.self, decoder: JSONDecoder())
        .compactMap { $0.args?.foo }
        .replaceError(with: "")
    let cancel = latestText.sink { completion in
        print(completion)
    } receiveValue: { ret in
        print(ret)
    }
    Global.cancel = cancel
}

