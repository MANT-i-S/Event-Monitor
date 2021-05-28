//
//  EventMonitor.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/22/21.
//

import Foundation

class EventMonitor {
    
    let urlBase = "https://api.seatgeek.com/2"
    let urlEvents = "/events"
    let clientID = "client_id=MjE5NzM2NTl8MTYyMTU1MTkxNS4yMTQ2MTM0"
    let clientSecret = "client_secret=22570c25d57fe1c1b3a3727212294b465f81de226963cca9abde8158bbbda8d4"
    
    var events = [Event]()
    var page = 1
    var searchRequest = ""
    var totalEventsWithThisRequest = 0
    
    func clearEventsArray() {
        if events.isEmpty == false {
            events.removeAll()
        }
    }
    
    func getData() {
        let urlString = urlBase + urlEvents + "?" + clientID + "&" + clientSecret + "&" + searchRequest + "&" + "page=\(page)"
        
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            parse(json: data)
        } else {
            assert(true, "EventMonitor.getData() coudn't get content of URL - \(urlString)")
        }
    }
    
    func parse(json: Data) {
        let newJson = try? JSONSerialization.jsonObject(with: json, options: [])
        if let eventDictionary = newJson as? [String: Any],
           let eventsArray = eventDictionary["events"] as? [Any] {
            if let metaDict = eventDictionary["meta"] as? [String: Any]{
                totalEventsWithThisRequest = metaDict["total"] as? Int ?? 0
            }
            for event in eventsArray {
                if let eventDict = event as? [String:Any],
                   let tempEvent = Event(dictionary: eventDict) {
                    events.append(tempEvent)
                }
            }
        }
    }
}
