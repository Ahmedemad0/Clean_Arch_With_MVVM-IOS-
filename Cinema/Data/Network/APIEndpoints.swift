//
//  APIEndpoints.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation


struct APIEndpoints {
    
    
    static func getMovies(with moviesRequestTDO: MoviesRequestTDO)-> EndPoint<MoviesResponseTDO> {
        return EndPoint(path: "v2/list_movies.json",
                        method: .get,
                        parametersEncodable: moviesRequestTDO)
    }
    
    
}
