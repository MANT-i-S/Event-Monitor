//
//  Event.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import Foundation

struct Event {
    
    var id: String
    var title: String
    var displayLocation: String
    var displayDateTime: String
    var image: String
    
    init? (json event: [String: Any]) {
        guard let id = event["id"] as? String,
                    let title = event["title"] as? String,
                    let dateTime = event["datetime_local"], //TODO format this before storing as property
                    let venue = event["venue"] as? [String: Any],
                    let location = venue["display_location"] as? String,
                    let performers = event["performers"] as? [Any],
                    let image
                else {
                    return nil
                }
        
        var meals: Set<Meal> = []
        for string in mealsJSON {
            guard let meal = Meal(rawValue: string) else {
                return nil
            }

            meals.insert(meal)
        }

        self.name = name
        self.coordinates = (latitude, longitude)
        self.meals = meals
    }
}
