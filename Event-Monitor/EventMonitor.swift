//
//  EventMonitor.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/22/21.
//

import Foundation

class EventMonitor {
    
    var events = [Event]()
    
    func getDataFrom() { //TODO breakdown url string at least put it in body of eventmonitor.
        let urlString = "https://api.seatgeek.com/2/events?client_id=MjE5NzM2NTl8MTYyMTU1MTkxNS4yMTQ2MTM0&client_secret=22570c25d57fe1c1b3a3727212294b465f81de226963cca9abde8158bbbda8d4&q=football"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        
        let newJson = try? JSONSerialization.jsonObject(with: json, options: [])
        if let eventDictionary = newJson as? [String: Any] {
            if let array = eventDictionary["events"] as? [Any] {
                print("Current number of events = \(array.count)")
                for index in array.indices {
                    if let dictionary = array[index] as? [String:Any] {
                        //events[index].id = dictionary["id"] as! String //TODO figure out how to cast from Any...
                        print("Id of this event is \(dictionary["id"]!)")
                        //events[index].title = dictionary["title"] as! String
                        print("Name of this event is \(dictionary["title"]!)")
                        let date = String(describing: type(of: (dictionary["datetime_local"]!)))
                        print("Date is type of \(date)")
                        
                        let RFC3339DateFormatter = DateFormatter()
                        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        let datetime = RFC3339DateFormatter.date(from: dictionary["datetime_local"] as! String)
                        
                        RFC3339DateFormatter.dateFormat = "EEEE, d MMM yyyy h:mm a"
                        let datelabel = RFC3339DateFormatter.string(from: datetime!)
                        print("Datelabel time looks like this \(datelabel)")
                        print("Formated time looks like this \(datetime)")
                        
                        print("Date time \(dictionary["datetime_local"]!)")
                        if let venueDict = dictionary["venue"] as? [String:Any] {
                            print("Location is \(venueDict["display_location"]!)")
                        }
                        if let performersArray = dictionary["performers"] as? [Any] {
                            for performer in performersArray {
                                if let performerDict = performer as? [String:Any] {
                                    if performerDict["image"] != nil {
                                        print("Picture url is \(performerDict["image"]!)")
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
