//
//  UseCase.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation


protocol UseCase {
    @discardableResult
    func start()-> Cancellable?
}
