//
//  NetworkErrorLogger.swift
//  Cinema
//
//  Created by Ahmed Emad on 19/07/2022.
//

import Foundation

public protocol NetworkErrorLogger {
    func log(urlRequest: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

public final class DefaultNetworkErrorLogger: NetworkErrorLogger{
    public init() { }
    
    public func log(urlRequest: URLRequest){
        print("-------------")
        print("request: \(urlRequest.url!)")
        print("headers: \(urlRequest.allHTTPHeaderFields!)")
        print("method: \(urlRequest.httpMethod!)")
        print("-------------")

        if let httpBody = urlRequest.httpBody, let result = (try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]? {
            print("body: \(String(describing: result))")
            
        }else if let httpBody = urlRequest.httpBody , let result = String(data: httpBody, encoding: .utf8){
            print("body: \(String(describing: result))")

        }
    }
    
    public func log(responseData data: Data?, response: URLResponse?){
        guard let data = data else {return}
        
        if let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
            print("response data: \(String(describing: dataDictionary))")
        }
    }
    
    public func log(error: Error){
        print(error)
    }
}
