//
//  ResponseDecoder.swift
//  Cinema
//
//  Created by Ahmed Emad on 19/07/2022.
//

import Foundation

public protocol ResponseDecoder{
    func decode<T:Decodable>(_ data: Data) throws -> T
}

public class JSONResponseDecoder: ResponseDecoder {
    
    private let jsonDecoder = JSONDecoder()
    init() {}
    
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case defaultKey = ""
    }
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        }else {
            let context = DecodingError.Context(codingPath: [CodingKeys.defaultKey], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
