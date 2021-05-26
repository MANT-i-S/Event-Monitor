//
//  ViewController.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var detailsTitleText = String()
    var detailsImage = UIImage()
    var detailsTimeDateText = String()
    var detailsLocationText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = detailsTitleText
        label.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = label
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        detailsImageLabel.image = detailsImage
        detailsDateTimeLabel.text = detailsTimeDateText
        detailsLocationLabel.text = detailsLocationText
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsImageLabel: UIImageView!
    @IBOutlet weak var detailsDateTimeLabel: UILabel!
    @IBOutlet weak var detailsLocationLabel: UILabel!
    
    @IBAction func favoriteButtonTouch(_ sender: UIBarButtonItem) {
        
    }
}

