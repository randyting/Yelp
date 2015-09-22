//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController{
  
  @IBOutlet weak var businessesTableView: UITableView!
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
    searchForBusinesses()
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
    navigationItem.titleView = searchBar
  }
  
  func setupNavigationItem(navigationItem: UINavigationItem) {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Filter", style: .Plain, target: self, action: "filterButtonClicked:")
  }
  
  // MARK: - Behavior
  
  func filterButtonClicked(sender: BusinessesViewController) {
    print("Clicked filter button")
  }
  
  func searchForBusinesses() {
    Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.businessesTableView.reloadData()
      })
    })
  }
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}

extension BusinessesViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath)
    
    let business = businesses[indexPath.row]
    
    cell.textLabel!.text = business.name!
    
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
