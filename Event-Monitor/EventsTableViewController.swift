//
//  EventsTableViewController.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
}

class EventsTableViewController: UITableViewController {
    
    var eventMonitor = EventMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventMonitor.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventMonitor.events.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "EventCellSegue":
                if let cell = sender as? EventTableViewCell,
                   let indexPath = tableView.indexPath(for: cell),
                   let seguedToMVC = segue.destination as? DetailsViewController {
                    seguedToMVC.eventMonitor = self.eventMonitor
                    seguedToMVC.eventIndex = indexPath.row
                }
            default: break
            }
        }
    }
    
    private func drawLogoIn(_ image: UIImage, _ logo: UIImage, position: CGPoint) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            logo.draw(in: CGRect(origin: position, size: logo.size))
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if let myTVC = cell as? EventTableViewCell,
           indexPath.row <= eventMonitor.events.count - 1 {
            myTVC.titleLabel?.text = eventMonitor.events[indexPath.row].title
            myTVC.locationLabel?.text = eventMonitor.events[indexPath.row].displayLocation
            myTVC.dateTimeLabel?.text = eventMonitor.events[indexPath.row].displayDateTime
            
            var displayImage = UIImage(named: "noImagePlaceholder")
            
            if let imageData = eventMonitor.events[indexPath.row].imageData {
                if let newImage = UIImage(data: imageData) {
                    displayImage = newImage
                }
            }
            
            if eventMonitor.events[indexPath.row].isFavorite == true {
                let heartConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .black)
                if let systemHeartImage = UIImage(systemName: "heart.fill", withConfiguration: heartConfig)?.withTintColor(UIColor.red) {
                    displayImage = drawLogoIn(displayImage!, systemHeartImage, position: CGPoint(x:0,y:0))
                }
            }
            
            myTVC.imageLabel?.image = displayImage
            
            //If user gets to the buttom of table get next page from events.
            if indexPath.row == self.eventMonitor.events.count - 1 && indexPath.row >= 9 {
                
                //Spinner indicator - loading more events.
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(45))
                self.tableView.tableFooterView = spinner
                //If totalevents amount more then current page * 10(events loading per page) then hide activity monitor spinner
                self.tableView.tableFooterView?.isHidden = eventMonitor.totalEventsWithThisRequest < eventMonitor.page * 10
                
                eventMonitor.page += 1
                let textBackgroundQueue = DispatchQueue.global(qos: .userInitiated)
                textBackgroundQueue.async {
                    self.eventMonitor.getData()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        return cell
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
