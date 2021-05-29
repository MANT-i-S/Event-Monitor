//
//  ViewController.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var eventMonitor = EventMonitor()
    var eventIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        detailsTitleLabel.text = eventMonitor.events[eventIndex].title
        
        var displayImage = UIImage(named: "noImagePlaceholder")
        if let imageData = eventMonitor.events[eventIndex].imageData {
            if let newImage = UIImage(data: imageData) {
                displayImage = newImage
            }
        }
        
        detailsImageLabel.image = displayImage
        
        detailsDateTimeLabel.text = eventMonitor.events[eventIndex].displayDateTime
        detailsLocationLabel.text = eventMonitor.events[eventIndex].displayLocation
        
        if eventMonitor.events[eventIndex].isFavorite == true {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
    }
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsImageLabel: UIImageView!
    @IBOutlet weak var detailsDateTimeLabel: UILabel!
    @IBOutlet weak var detailsLocationLabel: UILabel!
    
    @IBAction func favoriteButtonTouch(_ sender: UIBarButtonItem) {
        if eventMonitor.events[eventIndex].isFavorite == true {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            self.navigationItem.rightBarButtonItem?.tintColor = .none
            UserDefaults.standard.removeObject(forKey: String(eventMonitor.events[eventIndex].id))
            eventMonitor.events[eventIndex].isFavorite = false
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            UserDefaults.standard.setValue(true, forKey: String(eventMonitor.events[eventIndex].id))
            eventMonitor.events[eventIndex].isFavorite = true
        }
    }
}

