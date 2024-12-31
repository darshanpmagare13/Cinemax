//
//  RealmMoviesModel.swift
//  Cinemax
//
//  Created by IPS-177  on 19/04/24.
//

import Foundation
import RealmSwift

class RealmMoviesModel: Object {
    let movieId = RealmOptional<Int>() // Using RealmOptional<Int> to represent an optional Int
    convenience init(movieId: Int) {
        self.init()
        self.movieId.value = movieId // Assigning value to RealmOptional
    }
}


