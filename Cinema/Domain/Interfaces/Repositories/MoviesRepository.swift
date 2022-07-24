//
//  MoviesRepository.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation


protocol MoviesRepository {
    
    @discardableResult
    func fetchMovies(page: Int, completion: @escaping(Result<MoviesList, Error>)-> Void)-> Cancellable?
}
