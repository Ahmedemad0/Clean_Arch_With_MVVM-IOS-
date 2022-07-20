//
//  EndPoint+Extensions.swift
//  Cinema
//
//  Created by Ahmed Emad on 19/07/2022.
//

import Foundation

extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)"}
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
            
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
