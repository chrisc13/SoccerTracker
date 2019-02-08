//
//  StatsEntity+CoreDataProperties.swift
//  SoccerTraccer
//
//  Created by Chris Carbajal on 11/6/18.
//  Copyright © 2018 Chris Carbajal. All rights reserved.
//
//

import Foundation
import CoreData


extension StatsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatsEntity> {
        return NSFetchRequest<StatsEntity>(entityName: "StatsEntity")
    }

    @NSManaged public var goals: Double
    @NSManaged public var assists: Double
    @NSManaged public var date: String?
    @NSManaged public var matchpicture: NSData?
    @NSManaged public var minutes: Double
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var temp: String?
    @NSManaged public var wind: String?
    @NSManaged public var humidity: Double
    
    
}
