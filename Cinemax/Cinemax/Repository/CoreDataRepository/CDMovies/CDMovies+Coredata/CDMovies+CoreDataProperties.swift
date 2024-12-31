//
//  CDMovies+CoreDataProperties.swift
//  Cinemax
//
//  Created by IPS-161 on 04/04/24.
//
//

import Foundation
import CoreData


extension CDMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovies> {
        return NSFetchRequest<CDMovies>(entityName: "CDMovies")
    }

    @NSManaged public var id: Int64

}

extension CDMovies : Identifiable {

}
