import Combine
import Foundation

struct Response: Decodable {
    struct Foo: Decodable {
        let foo: String
    }
    let args: Foo?
}

let input = PassthroughSubject<String, Error>()

let session = check("URL Session") {
    input.flatMap { text in
        URLSession.shared
            .dataTaskPublisher(for: URL(string: "https://httpbin.org/get?foo=\(text)")!)
            .map { data, _ in data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .compactMap { $0.args?.foo }
    }
}

input.send("hello")
input.send("world")
input.send(completion: .finished)

