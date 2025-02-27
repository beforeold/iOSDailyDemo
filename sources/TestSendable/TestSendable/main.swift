import Foundation

print("begin")

struct Client: Sendable {
  var fetch: @Sendable () async throws -> String
}

let client = Client {
  try await Task.sleep(for: .seconds(1))
  return "some data for the client"
}

class Model {
  var name: String? = nil
}

let model = Model()
model.name = "brook"

Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [name = model.name] _ in
  Task {
    print("name:", name ?? "null")
    // print(#isolation)
    let value = try await client.fetch()
    print("fetched value:", value)
  }
}

try await Task.sleep(for: .seconds(5))
print("end")
