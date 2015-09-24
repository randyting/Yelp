//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController{
  
  // MARK: - Constants
  
  let businessReusableCellIdentifier = "BusinessCell"
  let filtersViewSegueIdentifier = "com.randy.FiltersViewSegue"
  
  // MARK: - Storyboard Objects
  
  @IBOutlet weak var businessesTableView: UITableView!
  
  // MARK: - Properties
  
  var businesses: [Business]!
  let searchBar = UISearchBar()
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    setupSearchBar(searchBar)
    setupNavigationItem(navigationItem)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView(businessesTableView)
    searchForBusinessesWithFilter([String: AnyObject]())
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Initialization
  
  func setupTableView(tableView: UITableView!) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  func setupSearchBar(searchBar: UISearchBar) {
    searchBar.sizeToFit()
    navigationItem.titleView = searchBar
  }
  
  func setupNavigationItem(navigationItem: UINavigationItem) {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Filter", style: .Plain, target: self, action: "filterButtonClicked:")
  }
  
  // MARK: - Behavior
  
  func filterButtonClicked(sender: BusinessesViewController) {
    performSegueWithIdentifier(filtersViewSegueIdentifier, sender: self)
  }
  
  func searchForBusinessesWithFilter(filter: [String:AnyObject]) {
//    Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//      self.businesses = businesses
//      dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.businessesTableView.reloadData()
//      })
//    })
    Business.searchWithTerm("restaurants", sort: nil, categories: filter["categories"] as? [String], deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              self.businessesTableView.reloadData()
            })
    }
  }
  
  // MARK: - Navigation
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == filtersViewSegueIdentifier {
      ((segue.destinationViewController as! UINavigationController).topViewController as! FiltersViewController).delegate = self
    }
  }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filter: [String : AnyObject]) {
    searchForBusinessesWithFilter(filter)
  }
}

extension BusinessesViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(businessReusableCellIdentifier, forIndexPath: indexPath) as! BusinessTableViewCell
    
    cell.business = businesses[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let businesses = businesses {
      return businesses.count
    }
    return 0
  }
  
}

extension BusinessesViewController: UISearchBarDelegate {
  
}
