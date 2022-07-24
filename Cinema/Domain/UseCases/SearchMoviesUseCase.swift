//
//  SearchMoviesUseCase.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation

protocol SearchMoviesUseCase {
    
}


final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    
    let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func excute(requestValue: SearchMoviesUseCaseValue, completion: @escaping(Result<MoviesList, Error>)-> Void)-> Cancellable? {
        return moviesRepository.fetchMovies(page: requestValue.page) { result in
            completion(result)
        }
    }
    
}


struct SearchMoviesUseCaseValue {
    let page: Int
}
