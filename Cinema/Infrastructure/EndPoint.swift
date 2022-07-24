//
//  EndPoint.swift
//  Cinema
//
//  Created by Ahmed Emad on 18/07/2022.
//

import Foundation

public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

public class EndPoint<R>: ResponseRequestable{
    public typealias Response = R
    
    public let path: String
    public let isFullPath: Bool
    public let method: HTTPMethodType
    public let headers: [String: String]
    public let parametersEncodable: Encodable?
    public let parameters: [String: Any]
    public let bodyParametersEncodable: Encodable?
    public let bodyParameters: [String: Any]
    public let bodyEncoding: BodyEncoding
    public let responseDecoder: ResponseDecoder
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType,
         headers: [String: String] = [:],
         parametersEncodable: Encodable? = nil,
         parameters: [String: Any] = [:],
         bodyParametersEncodable: Encodable? = nil,
         bodyParameters: [String: Any] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData,
         responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headers = headers
        self.parametersEncodable = parametersEncodable
        self.parameters = parameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.responseDecoder = responseDecoder
    }
}

public protocol Requestable {
    var path: String {get}
    var isFullPath: Bool {get}
    var method: HTTPMethodType {get}
    var headers: [String: String] {get}
    var parametersEncodable: Encodable? {get}
    var parameters: [String: Any] {get}
    var bodyParametersEncodable: Encodable? {get}
    var bodyParameters: [String: Any] {get}
    var bodyEncoding: BodyEncoding {get}
    
    func urlRequest(with configuration: NetworkConfigrable) throws -> URLRequest
}

public protocol ResponseRequestable: Requestable {
    
    associatedtype Response
    
    var responseDecoder: ResponseDecoder {get}
}

enum RequestGenerationError: Error {
    case componentsError
}

extension Requestable {
    func url(with configuration: NetworkConfigrable) throws -> URL {
        let baseURL = configuration.baseURL.absoluteString.last != "/" ? configuration.baseURL.absoluteString + "/" : configuration.baseURL.absoluteString
        
        let endPoint = isFullPath ? path : baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endPoint) else {throw RequestGenerationError.componentsError}
        var urlQueryItems = [URLQueryItem]()
        
        let parameters = try parametersEncodable?.toDictionary() ?? self.parameters
        parameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        configuration.parameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else {throw RequestGenerationError.componentsError}
        return url
    }
    
    public func urlRequest(with configuration: NetworkConfigrable) throws -> URLRequest {
        let url = try self.url(with: configuration)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = configuration.headers
        headers.forEach {
            allHeaders.updateValue($1, forKey: $0)
        }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
}

private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding)-> Data?{
    switch bodyEncoding {
    case .jsonSerializationData:
        return try? JSONSerialization.data(withJSONObject: bodyParameters)
    case .stringEncodingAscii:
        return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
    }
}
