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

class EventsTableViewController: UITableViewController, UISearchBarDelegate {

    var eventMonitor = EventMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventMonitor.getData()
        searchBar.delegate = self
        navigationController?.isNavigationBarHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar for current view controller
        self.navigationController?.isNavigationBarHidden = true;
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
       self.navigationController?.isNavigationBarHidden = false;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventMonitor.events.count
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let searchRequest = searchText.replacingOccurrences(of: " ", with: "+")
        eventMonitor.searchRequest = "q=" + searchRequest
        eventMonitor.page = 1
        self.eventMonitor.events.removeAll()
        print("Text from searchbar is \(searchText)")
        let textBackgroundQueue = DispatchQueue.global(qos: .userInteractive)
            textBackgroundQueue.async {
                self.eventMonitor.getData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if eventMonitor.events.isEmpty {
            self.eventMonitor.getData()
        }
        
        if let myTVC = cell as? EventTableViewCell {
            print("self.eventMonitor.events.count = \(self.eventMonitor.events.count)")
            myTVC.titleLabel?.text = eventMonitor.events[indexPath.row].title
            myTVC.locationLabel?.text = eventMonitor.events[indexPath.row].displayLocation
            myTVC.dateTimeLabel?.text = eventMonitor.events[indexPath.row].displayDateTime
            if let imageData = eventMonitor.events[indexPath.row].image {
                //myTVC.imageLabel?.image = UIImage(data: imageData)
                
                let newImage = UIImage(data: imageData)!
                UIGraphicsBeginImageContext(newImage.size)
                newImage.draw(at: CGPoint.zero)
                let heart = UIImage(named: "heart")
                var imageView = UIImageView(image: heart) //TODO this looks terrible, find out the nice way to mark event as favorite.
                imageView.setImageColor(color: UIColor.red)
                imageView.draw(CGRect(x: 0, y: 0, width: 50, height: 50))
                let newerImage = UIGraphicsGetImageFromCurrentImageContext()
                     UIGraphicsEndImageContext()
                myTVC.imageLabel?.image = newerImage
                
            } else {
                myTVC.imageLabel?.image = UIImage(named: "noImagePlaceholder")
            }
            print("Index path row = \(indexPath.row)")
            print("self.eventMonitor.events.count = \(self.eventMonitor.events.count)")
            if indexPath.row == self.eventMonitor.events.count - 1 {
                print("self.eventMonitor.events.count = \(self.eventMonitor.events.count)")
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

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
    self.backgroundColor = .none
  }
}
