//
//  NetworkConfigration.swift
//  Cinema
//
//  Created by Ahmed Emad on 18/07/2022.
//

import Foundation

public protocol NetworkConfigrable{
    var baseURL: URL {get}
    var headers: [String: String] {get}
    var parameters: [String: String] {get}
}


public struct ApiDataNetworkConfigration: NetworkConfigrable {
    public let baseURL: URL
    public let headers: [String : String]
    public let parameters: [String: String]
    
    public init(baseURL: URL, headers: [String: String] = [:], parameters: [String: String] = [:]){
        self.baseURL = baseURL
        self.headers = headers
        self.parameters = parameters
    }
}
