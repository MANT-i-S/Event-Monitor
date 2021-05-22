//
//  Event.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import Foundation

struct Event: Codable {
    var id: String = ""
    var title: String = ""
    var displayLocation: String = ""
    var localDateTime: String = ""
    var image: String = ""
}
