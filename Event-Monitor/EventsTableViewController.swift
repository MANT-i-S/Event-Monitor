//
//  EventsTableViewController.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/21/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}

class EventsTableViewController: UITableViewController {
    
    var myEvents = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.seatgeek.com/2/events?client_id=MjE5NzM2NTl8MTYyMTU1MTkxNS4yMTQ2MTM0&client_secret=22570c25d57fe1c1b3a3727212294b465f81de226963cca9abde8158bbbda8d4"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                //print(json!)
                if let eventDictionary = json as? [String: Any] { // make this array. then try to access event in a loop.
                    if let dictionary = eventDictionary["events"] as? [String: Any] {
                        print(dictionary) // Nested dictionary or array?
                    }
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    func parse(json: Data) {
//        let decoder = JSONDecoder()
//
//        do {
//            let jsonEvents = try decoder.decode(Events.self, from: json)
//            myEvents = jsonEvents.events
//            tableView.reloadData()
//        } catch {
//            print("Error in parsing JSON data")
//        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        if let myTVC = cell as? EventTableViewCell {
            myTVC.nameLabel?.text = myEvents[indexPath.row].name
            myTVC.locationLabel?.text = myEvents[indexPath.row].display_location
            myTVC.dateLabel?.text = myEvents[indexPath.row].datetime_utc
            //myTVC.imageLabel?.image = UIImage(named: "events[indexPath.row].isoCode")
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