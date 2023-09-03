import Combine
import Foundation

func loadPage(
    url: URL,
    handler: @escaping (Data?, URLResponse?, Error?) -> Void)
{
    URLSession.shared.dataTask(with: url) {
        data, response, error in
        handler(data, response, error)
    }.resume()
}

let future = check("Future") {
    Future<(Data, URLResponse), Error> { promise in
        loadPage(url: URL(string: "https://example.com")!) {
            data, response, error in
            if let data = data, let response = response {
                promise(.success((data, response)))
            } else {
                promise(.failure(error!))
            }
        }
    }
}

let subject = PassthroughSubject<Date, Never>()
Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    subject.send(Date())
}

let timer = check("Timer") {
    subject
}
