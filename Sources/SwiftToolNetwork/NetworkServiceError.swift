//
//  NetworkService.swift
//  
//
//  Created by Maksim Linkov on 21.03.2022.
//

import Foundation

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public enum NetworkServiceError: Error {
    case noToken
    case wrongUrl(String)
    case serverResponse(Int)
    case urlSession(Error)
    case noData
    case encoding(Error)
    case decoding(Error)
    case custom(String)
}

/// Service for sending network requests

public struct NetworkService {
    private  let urlSession = URLSession(configuration: .ephemeral)
    public init() { }
}

extension NetworkService: NetworkServiceProtocol {
    public func request(
        method: RequestMethod,
        host: String,
        path: String,
        parameters: [String : String],
        headers: [String : String],
        body: Data?,
        handler: @escaping (Result<Data, Error>) -> Void
    ) {
        
        let result = createRequest(method: method, host: host, path: path, parameters: parameters, headers: headers, body: body)
        
        switch result {
        case .success(let request):
            send(request: request, handler: handler)
        case .failure(let error):
            handler(.failure(error))
        }
    }
}

private extension NetworkService {
    func createRequest(
        method: RequestMethod,
        host: String,
        path: String,
        parameters: [String : String],
        headers: [String : String],
        body: Data?) -> Result<URLRequest, Error>  {
        
        let urlText = host + path
        
        guard var urlComponents = URLComponents(string: urlText) else {
            return .failure(NetworkServiceError.wrongUrl(urlText))
        }
        
        // add parameters to request
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents.url else {
            return .failure(NetworkServiceError.wrongUrl(urlText))
        }
        
        var request = URLRequest(url: url)
        
        // set body
        request.httpBody = body
        
        // add headers
        request.allHTTPHeaderFields = headers
        
        // request method
        request.httpMethod = method.rawValue
        print("📨 Request created successfully:", request.url?.absoluteString ?? "")
        
        return .success(request)
        
    }
    
    func send(request: URLRequest,  handler: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let data = data {
                handler(.success(data))
                print("🏁 response received!")
            } else if let error = error {
                guard let response = response as? HTTPURLResponse else {
                    return handler(.failure(NetworkServiceError.urlSession(error)))
                    //return seal.reject(NetworkScriptError.urlSession(error))
                }
                handler(.failure(NetworkServiceError.serverResponse(response.statusCode)))
            } else {
                handler(.failure(NetworkServiceError.noData))
            }
        }.resume()
    }
}
