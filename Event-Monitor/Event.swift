//
//  Event.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import Foundation

struct Event: Codable {
    var name: String
    var display_location: String
    var datetime_utc: String //probably type Date
    var image: String
}
