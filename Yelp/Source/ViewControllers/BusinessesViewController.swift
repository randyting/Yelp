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
  @IBOutlet weak var businessTableViewBottomToSuperConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  
  var businesses: [Business]!
  var searchedBusinesses: [Business]!
  var searchController: UISearchController!
  var searchBar: UISearchBar!
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    //    setupSearchController()
    setupSearchBar()
    setupNavigationItem(navigationItem)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupChangeTableViewFrameWhenKeyboardIsShownOrHides()
    setupTableView(businessesTableView)
    searchForBusinessesWithFilter(Filter())
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Initialization
  
  func setupChangeTableViewFrameWhenKeyboardIsShownOrHides(){
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardDidHideNotification, object: nil)
  }
  
  func setupSearchBar() {
    searchBar = UISearchBar()
    searchBar.delegate = self
    searchBar.placeholder = "Restaurant"
    searchBar.sizeToFit()
    searchBar.returnKeyType = UIReturnKeyType.Done
    navigationItem.titleView = searchBar
  }
  
  func setupTableView(tableView: UITableView!) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.sizeToFit()
    navigationItem.titleView = searchController.searchBar
    definesPresentationContext = true
    
  }
  
  func setupNavigationItem(navigationItem: UINavigationItem) {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Filter", style: .Plain, target: self, action: "filterButtonClicked:")
  }
  
  // MARK: - Behavior
  
  func willShowKeyboard(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let kbSize = ((userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size)!
      let durationValue = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!
      let animationDuration = durationValue.doubleValue
      let curveValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)!
      let animationCurve = curveValue.integerValue
      
      UIView.animateWithDuration(animationDuration,
        delay: 0.0,
        options: UIViewAnimationOptions(rawValue: UInt(animationCurve) << 16),
        animations: { () -> Void in
          self.businessesTableView.frame = CGRectMake(0, 0, self.businessesTableView.frame.size.width, self.businessesTableView.frame.size.height - kbSize.height)
          self.searchBar.showsCancelButton = true
        }, completion: nil)
    }
  }
  
  func willHideKeyboard(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let durationValue = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!
      let animationDuration = durationValue.doubleValue
      let curveValue = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)!
      let animationCurve = curveValue.integerValue
      
      UIView.animateWithDuration(animationDuration,
        delay: 0.0,
        options: UIViewAnimationOptions(rawValue: UInt(animationCurve) << 16),
        animations: { () -> Void in
          self.businessesTableView.frame = CGRectMake(0, 0, self.businessesTableView.frame.size.width, self.view.frame.height)
          self.searchBar.showsCancelButton = false
        }, completion: nil)
    }
  }
  
  func filterButtonClicked(sender: BusinessesViewController) {
    performSegueWithIdentifier(filtersViewSegueIdentifier, sender: self)
  }
  
  func searchForBusinessesWithFilter(filter: Filter) {
    
    Business.searchWithTerm("restaurants", sort: filter.sort, categories: filter.categories, deals: filter.deals, radius: filter.radius) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      self.searchedBusinesses = businesses
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.businessesTableView.reloadData()
      })
    }
  }
  
  // MARK: - Helper
  
  func searchBusinessesWithSearchText(searchText: String) -> [Business] {
    
    let pred =  NSPredicate(format: "name CONTAINS[c] %@", searchText)
    let foundBusinesses = businesses.filter({ pred.evaluateWithObject($0)})
    
    return foundBusinesses
  }
  
  // MARK: - Navigation
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == filtersViewSegueIdentifier {
      ((segue.destinationViewController as! UINavigationController).topViewController as! FiltersViewController).delegate = self
    }
  }
  
  
}

// MARK: - Delegate Methods

extension BusinessesViewController: FiltersViewControllerDelegate {
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filter: Filter) {
    searchForBusinessesWithFilter(filter)
  }
}

extension BusinessesViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(businessReusableCellIdentifier, forIndexPath: indexPath) as! BusinessTableViewCell
    
    cell.business = searchedBusinesses[indexPath.row]
    
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let searchedBusinesses = searchedBusinesses {
      return searchedBusinesses.count
    }
    return 0
  }
  
}

extension BusinessesViewController: UISearchResultsUpdating{
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchText = searchController.searchBar.text!
    
    if searchText.characters.count > 0 {
      searchedBusinesses = searchBusinessesWithSearchText(searchText)
    }
    businessesTableView.reloadData()
  }
}

extension BusinessesViewController: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    let searchText = searchBar.text!
    
    if searchText.characters.count > 0 {
      searchedBusinesses = searchBusinessesWithSearchText(searchText)
    } else {
      searchedBusinesses = businesses
    }
    
    businessesTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.text = ""
    self.searchBar(searchBar, textDidChange: searchBar.text!)
    searchBar.resignFirstResponder()
  }
  
  
}
