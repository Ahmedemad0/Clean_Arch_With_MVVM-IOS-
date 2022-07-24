//
//  MoviesResponseTDO+Mapping.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation

struct MoviesResponseTDO: Decodable {
    var status: String
    var data: MoviesDataTDO
}


extension MoviesResponseTDO {
    
    struct MoviesDataTDO: Decodable {
        var limit: Int
        var movies: [MovieTDO]
        
        struct MovieTDO: Decodable {
            var id: Int
            var title: String
        }
        
    }
    
    
    

}


extension MoviesResponseTDO {
    func toDomain()-> MoviesList {
        return .init(status: status, data: data.toDomain())
    }
}

extension MoviesResponseTDO.MoviesDataTDO {
    func toDomain()-> MoviesData {
        return .init(limit: limit, movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseTDO.MoviesDataTDO.MovieTDO {
    func toDomain()-> Movie {
        return .init(id: Movie.Identifier(id), title: title)
    }
}
