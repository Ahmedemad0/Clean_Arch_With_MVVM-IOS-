//
//  ErrorHandler.swift
//  Cinema
//
//  Created by Ahmed Emad on 19/07/2022.
//

import Foundation


public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

public protocol DataTransferErrorResolver{
    func resolve(error: NetworkError) -> Error
}

public protocol DataTransferErrorLogger{
    func log(error: Error)
}


public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() { }
    public func resolve(error: NetworkError) -> Error {
        return error
    }
}


public class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    public func log(error: Error) {
        print("-------------------")
        print("Data transfer error logger:  \(error)")
    }
    
    
}
