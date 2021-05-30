//
//  Event.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import Foundation

struct Event {
    
    var id: Int
    var buyTicketsURL: String
    var title: String
    var displayLocation: String
    var displayDateTime: String?
    var dateTime: Date?
    var imageData: Data?
    var isFavorite = false
    
    private func getImageData(from url: URL?) -> Data? {
        if let imageURL = url,
           let imageData = try? Data(contentsOf: imageURL) {
            return imageData
        } else {
            return nil
        }
    }
    
    init? (dictionary event: [String: Any]) {
        guard let id = event["id"] as? Int,
                    let buyTicketsURL = event["url"] as? String,
                    let title = event["title"] as? String,
                    let dateTimeStr = event["datetime_local"] as? String,
                    let venue = event["venue"] as? [String: Any],
                    let location = venue["display_location"] as? String,
                    let performers = event["performers"] as? [Any]
                else {
                    return nil
                }
        
        //Take datetime from format in json and reformat to user friendly format.
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dateTime = dateFormatter.date(from: dateTimeStr) {
            self.dateTime = dateTime
            dateFormatter.dateFormat = "EEEE, d MMM yyyy h:mm a"
            let displayDateTime = dateFormatter.string(from: dateTime)
            self.displayDateTime = displayDateTime
        } else {
            self.dateTime = nil
            self.displayDateTime = nil
        }
        //Go through performers and use first existing image.
        self.id = id
        self.buyTicketsURL = buyTicketsURL
        self.title = title
        self.displayLocation = location
        let isTrue = UserDefaults.standard.bool(forKey: String(id))
        if isTrue == true {
            self.isFavorite = true
        }
        
        for performer in performers {
            if let performerDict = performer as? [String: Any],
               let imageStr = performerDict["image"] as? String? {
            if imageStr != nil {
                self.imageData = getImageData(from: URL(string: imageStr!))
                break
                }
            }
        }
    }
}
