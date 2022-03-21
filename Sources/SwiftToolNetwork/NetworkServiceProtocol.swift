//
//  NetworkServiceProtocol.swift
//  
//
//  Created by Maksim Linkov on 21.03.2022.
//

import Foundation

public protocol NetworkServiceProtocol {
    /// Отправляет запрос на указанный адрес
    /// - Parameters:
    ///   - method: тип запроса (например, .get, .post, .put ...)
    ///   - host: хост в url (например, "www.google.com")
    ///   - path: путь в url (например, "/search")
    ///   - parameters: словарь передаваемых параметров
    ///   - headers: словарь передаваемых хедеров
    ///   - body: данные для отправки
    func request(
        method: RequestMethod,
        host: String,
        path: String,
        parameters: [String: String],
        headers: [String: String],
        body: Data?,
        handler: @escaping (Result<Data, Error>) -> Void
    )
}

public extension NetworkServiceProtocol {
    func request(
        method: RequestMethod = .get,
        host: String,
        path: String = "",
        parameters: [String: String] = [:],
        headers: [String: String] = [:],
        body: Data? = nil,
        handler: @escaping (Result<Data, Error>) -> Void
    ) {
        request(method: method, host: host, path: path, parameters: parameters, headers: headers, body: body, handler: handler)
    }
}

