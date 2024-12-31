//
//  RealmDataRepositoryManager.swift
//  Cinemax
//
//  Created by IPS-177  on 19/04/24.
//

import Foundation
import RealmSwift

protocol RealmDataRepositoryManagerProtocol {
    func addMovieToWishlist(movie: RealmMoviesModel)
    func getMovieFromWishlist()->[RealmMoviesModel]
    func deleteMovieFromWishlist(movieId: Int)
    func deleteAllMoviesFromWishlist() 
}

class RealmDataRepositoryManager {
    static let shared = RealmDataRepositoryManager()
    private init(){}
}

extension RealmDataRepositoryManager: RealmDataRepositoryManagerProtocol {
    
    func addMovieToWishlist(movie: RealmMoviesModel) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(movie)
            }
        } catch {
            print(error)
        }
    }
    
    func getMovieFromWishlist()->[RealmMoviesModel] {
        var tempArray = [RealmMoviesModel]()
        do {
            let realm = try Realm()
            let results = realm.objects(RealmMoviesModel.self)
            for movies in results {
                tempArray.append(movies)
            }
        } catch {
            print(error)
        }
        return tempArray
    }
    
    func deleteMovieFromWishlist(movieId: Int){
        do {
            let realm = try Realm()
            guard let movieToDelete = realm.objects(RealmMoviesModel.self).filter("movieId == %@", movieId).first else {
                // Movie with the given ID not found
                return
            }
            try realm.write {
                realm.delete(movieToDelete)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteAllMoviesFromWishlist() {
        do {
            let realm = try Realm()
            let allMovies = realm.objects(RealmMoviesModel.self)
            try realm.write {
                realm.delete(allMovies)
            }
        } catch {
            print(error)
        }
    }
    
}
