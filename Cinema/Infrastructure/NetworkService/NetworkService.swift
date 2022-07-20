//
//  NetworkService.swift
//  Cinema
//
//  Created by Ahmed Emad on 18/07/2022.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case genericError(Error)
    case urlGeneration
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endPoint: Requestable, complerion: @escaping CompletionHandler)-> NetworkCancellable?

}

public final class DefaultNetworkService {
    private let configuration: NetworkConfigrable
    private let networkSessionManager: NetworkSessionManager
    private let errorLogger: NetworkErrorLogger
    
    init(configuration: NetworkConfigrable,
         networkSessionManager: NetworkSessionManager,
         errorLogger: NetworkErrorLogger) {
        
        self.configuration = configuration
        self.networkSessionManager = networkSessionManager
        self.errorLogger = errorLogger
    }
    
    private func request(urlRequest: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let sessionDataTask = networkSessionManager.request(urlRequest) {[weak self] data, response, requestError in
            guard let self = self else {return}
            if let requestError = requestError {
                
                var error: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                    
                }else{
                    error = self.resolveError(error: requestError)
                }
                
                self.errorLogger.log(error: error)
                completion(.failure(error))
                
            }else {
                self.errorLogger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
        
        errorLogger.log(urlRequest: urlRequest)
        
        return sessionDataTask
    }
    
    private func resolveError(error: Error)-> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .notConnected
        case .cancelled:
            return .cancelled
        default:
            return .genericError(error)
        }
    }
}


extension DefaultNetworkService: NetworkService {
    public func request(endPoint: Requestable, complerion: @escaping CompletionHandler)-> NetworkCancellable?{
        do{
            let urlRequest = try endPoint.urlRequest(with: configuration)
            return request(urlRequest: urlRequest, completion: complerion)
            
        }catch{
            complerion(.failure(.urlGeneration))
            return nil
        }
    }
}
