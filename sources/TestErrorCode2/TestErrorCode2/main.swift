import Foundation

public enum ParserError: Error {
  case parse
}

public enum APIError: Swift.Error {
  case request
  case network(code: Int, status: Int, error: Swift.Error, completionValues: Any?)
  case parser(ParserError, completionValues: Any?)
  case server(code: Int, message: String?, completionValues: Any?)
}

let errors: [APIError] = [
  .request,
  .network(code: 0, status: 0, error: ParserError.parse, completionValues: nil),
  .parser(.parse, completionValues: nil),
  .server(code: 0, message: nil, completionValues: nil)
]

errors.forEach { error in
  let nsError = error as NSError
  print(nsError.domain, nsError.code, nsError.localizedDescription, separator: "\t")
}
