//
//  GlobalEventViewController.swift
//  Event-Monitor
//
//  Created by Serhii Holiak on 5/27/21.
//

import UIKit

class GlobalEventViewController: UIViewController, UISearchBarDelegate {

    var eventsTableView = EventsTableViewController()
    var eventMonitor = EventMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "EmbeddedTable":
                if let seguedToMVC = segue.destination as? EventsTableViewController {
                    eventsTableView = seguedToMVC
                    eventsTableView.eventMonitor = self.eventMonitor
                }
            default: break
            }
        }
    }
    
    private var lastTextDidChange = Date().timeIntervalSinceReferenceDate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let secondsFromLastTextDidChange = Date().timeIntervalSinceReferenceDate - lastTextDidChange //TODO this is smart but should be way to stop recent searchbar action if its called second time. Maybe stop background activity as soon as getting in. Try it tommorow.
        
        print("eventMonitor.page = \(eventMonitor.page)")
        var searchRequest = searchText.trimmingCharacters(in: .whitespaces)
        searchRequest = searchRequest.replacingOccurrences(of: "[^A-Za-z0-9 ]+",
                                                           with: "",
                                                           options: [.regularExpression])
        searchRequest = searchRequest.split(separator: " ").joined(separator: " ")
        searchRequest = searchRequest.replacingOccurrences(of: " ", with: "+")
        searchRequest = searchRequest.isEmpty ? "" : "q=" + searchRequest
        if secondsFromLastTextDidChange > 1.0 && searchRequest != eventMonitor.searchRequest {
            eventMonitor.searchRequest = searchRequest
            eventMonitor.page = 1
            eventMonitor.clearEventsArray()
            print("Text from searchbar is '\(searchText)'")
            print("eventMonitor.searchRequest is '\(eventMonitor.searchRequest)'")
            let textBackgroundQueue = DispatchQueue.global(qos: .userInteractive)
            textBackgroundQueue.async {
                self.eventMonitor.getData()
                DispatchQueue.main.async {
                    self.eventsTableView.tableView.reloadData()
                }
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
