//
//  RepositoryTask.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation


class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
