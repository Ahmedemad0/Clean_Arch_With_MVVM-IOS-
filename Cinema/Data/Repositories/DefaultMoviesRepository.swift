//
//  DefaultMoviesRepository.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation


final class DefaultMoviesRepository {
    let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    func fetchMovies(page: Int, completion: @escaping (Result<MoviesList, Error>) -> Void) -> Cancellable? {
        
        let requestTDO = MoviesRequestTDO(page: page)
        let task = RepositoryTask()
        
        if !task.isCancelled {
            
            let endponit = APIEndpoints.getMovies(with: requestTDO)
            
            task.networkTask = self.dataTransferService.request(with: endponit, completion: { result in
                switch result {
                    
                case .success(let responseTDO):
                    completion(.success(responseTDO.toDomain()))
                    
                case.failure(let error):
                    completion(.failure(error))
                }
            })
        }
        return task
    }
}
