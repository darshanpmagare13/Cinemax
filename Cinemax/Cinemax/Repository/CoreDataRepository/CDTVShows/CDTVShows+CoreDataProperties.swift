//
//  CDTVShows+CoreDataProperties.swift
//  Cinemax
//
//  Created by IPS-161 on 04/04/24.
//
//

import Foundation
import CoreData


extension CDTVShows {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTVShows> {
        return NSFetchRequest<CDTVShows>(entityName: "CDTVShows")
    }

    @NSManaged public var id: Int64

}

extension CDTVShows : Identifiable {

}
