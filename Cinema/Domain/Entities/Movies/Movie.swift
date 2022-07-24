//
//  Movie.swift
//  Cinema
//
//  Created by Ahmed Emad on 23/07/2022.
//

import Foundation

struct Movie: Equatable, Identifiable {
    typealias Identifier = String

    var id: Identifier
    var title:String
}
