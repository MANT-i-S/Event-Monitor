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
    
    var searchTask: DispatchWorkItem?
    //private var lastTextDidChange = Date().timeIntervalSinceReferenceDate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Check if another search in process
        searchTask?.cancel()
        
        //Get rid of any extra symbols and whitespaces in searchText and add '+' sign between words.
        let searchRequest = searchText
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "[^A-Za-z0-9 ]+",
                                  with: "",
                                  options: [.regularExpression])
            .split(separator: " ")
            .joined(separator: " ")
            .replacingOccurrences(of: " ", with: "+")
        
        //Save new search request, go to page 1 of events, get rif of any previous events
        eventMonitor.searchRequest = searchRequest.isEmpty ? "" : "q=" + searchRequest
        eventMonitor.page = 1
        eventMonitor.clearEventsArray()
        
        //Create a new search task
        let task = DispatchWorkItem { [weak self] in
            let textBackgroundQueue = DispatchQueue.global(qos: .userInteractive)
            textBackgroundQueue.async {
                self?.eventMonitor.getData()
                DispatchQueue.main.async {
                    
                    //Create label for table footer
                    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
                    label.textAlignment = .center
                    label.text = "No results match your search criteria"
                    self?.eventsTableView.tableView.tableFooterView? = label
                    
                    //Show label for table footer only if no events found
                    self?.eventsTableView.tableView.tableFooterView?.isHidden = self?.eventMonitor.totalEventsWithThisRequest != 0
                    
                    self?.eventsTableView.tableView.reloadData()
                }
            }
        }
        
        self.searchTask = task
        //Execute current task only if task didn't cancel for half a second
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: task)
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
}
