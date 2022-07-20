//
//  DataTransferService.swift
//  Cinema
//
//  Created by Ahmed Emad on 18/07/2022.
//

import Foundation


public protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>)-> Void
    
    @discardableResult
    func request<T: Codable, E: ResponseRequestable>(with endPoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T

    @discardableResult
    func request<E>(with endPoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E: ResponseRequestable, E.Response == Void
}


public class DefaultDataTransferService {
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(networkService: NetworkService,
         errorResolver: DataTransferErrorResolver,
         errorLogger: DataTransferErrorLogger) {
        self.networkService = networkService
        self.errorResolver  = errorResolver
        self.errorLogger    = errorLogger
    }
    
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder)-> Result<T, DataTransferError>{
        do{
            guard let data = data else {
                return .failure(.noResponse)
            }
            
            let result: T = try decoder.decode(data)
            return .success(result)

        }catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError)-> DataTransferError{
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(error)
    }
}

extension DefaultDataTransferService: DataTransferService {
    public func request<T: Codable, E: ResponseRequestable>(with endPoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T {
        
        return networkService.request(endPoint: endPoint) {[weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endPoint.responseDecoder)
                DispatchQueue.main.async {
                    return completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let resolvedError = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    completion(.failure(resolvedError))
                }
            }
        }
    }
    
    public func request<E>(with endPoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E: ResponseRequestable, E.Response == Void {
        
        return networkService.request(endPoint: endPoint) {[weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    return completion(.success(()))
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
