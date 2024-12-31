//
//  CDMoviesManager.swift
//  Cinemax
//
//  Created by IPS-161 on 04/04/24.
//

import Foundation

protocol CDMoviesManagerProtocol {
    func addMovieToWishlist(movie:CDMoviesModel?,completion:@escaping (Bool) -> Void)
    func fetchMoviesFromWishlist(completion:@escaping(Result<[CDMoviesModel],Error>)->())
}

class CDMoviesManager {
    static let shared = CDMoviesManager()
    private init(){}
}

extension CDMoviesManager: CDMoviesManagerProtocol {
    
    func addMovieToWishlist(movie:CDMoviesModel?,completion:@escaping (Bool) -> Void){
        guard let movie = movie , let id = movie.id else{
            completion(false)
            return
        }
        let movieContext = CDMovies(context: CoreDataPersistance.shared.persistentContainer.viewContext)
        movieContext.id = Int64(id)
        CoreDataPersistance.shared.saveContext()
        completion(true)
    }
    
    func fetchMoviesFromWishlist(completion:@escaping(Result<[CDMoviesModel],Error>)->()){
        var tempMoviesArray = [CDMoviesModel]()
        do{
            let data = try CoreDataPersistance.shared.persistentContainer.viewContext.fetch(CDMovies.fetchRequest())
            for element in data{
                tempMoviesArray.append(CDMoviesModel(id:Int(element.id)))
            }
            completion(.success(tempMoviesArray))
        }catch let error {
            completion(.failure(error))
        }
    }
    
}
