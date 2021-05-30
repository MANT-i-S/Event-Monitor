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
    private var themeColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        themeColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        self.navigationItem.rightBarButtonItem?.tintColor = themeColor
        
        var displayImage = UIImage(named: "noImagePlaceholder")
        if let imageData = eventMonitor.events[eventIndex].imageData {
            if let newImage = UIImage(data: imageData) {
                displayImage = newImage
            }
        }
        
        detailsImageLabel.image = displayImage
        detailsTitleLabel.text = eventMonitor.events[eventIndex].title
        detailsDateTimeLabel.text = eventMonitor.events[eventIndex].displayDateTime
        detailsLocationLabel.text = eventMonitor.events[eventIndex].displayLocation
        
        if eventMonitor.events[eventIndex].isFavorite == true {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        }
    }
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsImageLabel: UIImageView!
    @IBOutlet weak var detailsDateTimeLabel: UILabel!
    @IBOutlet weak var detailsLocationLabel: UILabel!
    
    @IBAction func buyTicketsButton(_ sender: Any) {
        if let url = URL(string: eventMonitor.events[eventIndex].buyTicketsURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func favoriteButtonTouch(_ sender: UIBarButtonItem) {
        if eventMonitor.events[eventIndex].isFavorite == true {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            self.navigationItem.rightBarButtonItem?.tintColor = themeColor
            UserDefaults.standard.removeObject(forKey: String(eventMonitor.events[eventIndex].id))
            eventMonitor.events[eventIndex].isFavorite = false
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            UserDefaults.standard.setValue(true, forKey: String(eventMonitor.events[eventIndex].id))
            eventMonitor.events[eventIndex].isFavorite = true
        }
    }
}

