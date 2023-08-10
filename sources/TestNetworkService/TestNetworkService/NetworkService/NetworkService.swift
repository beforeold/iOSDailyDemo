//
//  NetworkService.swift
//  TestNetworkService
//
//  Created by Brook_Mobius on 8/9/23.
//

import Foundation
import Alamofire

public final class NetworkService {
  public let host: String
  
  public init(host: String) {
    self.host = host
  }
  
  
  @Protected private var headerMap: [String: String] = [:]
  
  public func setValue(_ value: String?, forHeader key: String) {
    $headerMap.write { map in
      map[key] = value
    }
  }
  
  public func request<P, T>(
    respOf type: T.Type,
    fromAPI api: API,
    parameter: P?,
    onSuccess: @escaping (T) -> Void,
    onFailure: @escaping (Error) -> Void
  ) where P: Encodable, T: Decodable {
    debugPrint(api.path, "request api")
    
    let url = buildURL(api: api)
    
    var requestHeaders: HTTPHeaders = .init()
    $headerMap.read { map in
      requestHeaders = .init(map)
    }
    
    let request = AF.request(
      url,
      method: api.isGet ? .get : .post,
      parameters: parameter,
      encoder: api.isGet ? URLEncodedFormParameterEncoder.default : JSONParameterEncoder(),
      headers: requestHeaders
    )
    
    request.responseDecodable(
      of: GenericRespesponse<T>.self,
      decoder: JSONDecoder()
    ) { result in
      switch result.result {
      case .success(let value):
        print(api.path, "parsed", value.code, value.message ?? "<no message>")
        
        guard value.code == 0 else {
          let nsError = NSError(domain: "NetworkService", code: -10000)
          onFailure(nsError)
          return
        }
        
        guard let data = value.data else {
          let nsError = NSError(domain: "NetworkService", code: -10001)
          onFailure(nsError)
          return
        }
        
        onSuccess(data)
        
      case .failure(let error):
        print(api.path, "failed", error)
        onFailure(error)
      }
    }
    
    request.resume()
  }
  
  private func buildURL(api: API) -> URL {
    let urlString = host.appending(api.path)
    let url = URL(string: urlString)!
    return url
  }
}


public struct GenericRespesponse<T>: Decodable where T: Decodable {
  var code: Int
  var message: String?
  var data: T?
}

private protocol _ArrayProtocol {
  
}

extension Array: _ArrayProtocol {
  
}

public struct Empty: Codable {
  public init() { }
}
