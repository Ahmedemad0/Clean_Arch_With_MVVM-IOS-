//
//  NetworkSessionManager.swift
//  Cinema
//
//  Created by Ahmed Emad on 19/07/2022.
//

import Foundation


public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ urlRequest: URLRequest, completion: @escaping CompletionHandler)-> NetworkCancellable
}


public class DefaultNetworkSessionManager: NetworkSessionManager {
    
    public init() {}
    
    public func request(_ urlRequest: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
}
