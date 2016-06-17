//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit
import MapKit

class BusinessesViewController: UIViewController{
  
  // MARK: - Constants
  
  let businessReusableCellIdentifier = "BusinessCell"
  let filtersViewSegueIdentifier = "com.randy.FiltersViewSegue"
  let detailsViewSegueIdentifier = "com.randy.DetailsViewSegue"
  
  // MARK: - Storyboard Objects
  
  
  @IBOutlet weak var businessesMapView: MKMapView!
  @IBOutlet weak var businessesTableView: UITableView!
  @IBOutlet weak var businessTableViewBottomToSuperConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  
  var businesses: [Business]!
  var searchedBusinesses: [Business]!
  var searchController: UISearchController!
  var searchBar: UISearchBar!
  var currentFilter = Filter()
  var newBusinessCount: Int = 0
  var currentLocation = CLLocationCoordinate2DMake(37.785771,-122.406165)
  
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
    searchForBusinessesWithFilter(currentFilter)
    setupTableView(businessesTableView)
    setupMapView()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Initialization
  
  func setupMapView() {
    businessesMapView.hidden = true
    businessesMapView.delegate = self
    businessesMapView.setRegion(MKCoordinateRegionMake(currentLocation, MKCoordinateSpanMake(0.1, 0.1)), animated: false)
  }
  
  func setupChangeTableViewFrameWhenKeyboardIsShownOrHides(){
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "willShowKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "willHideKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
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
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Map", style: .Plain, target: self, action: "mapButtonClicked:")
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
  
  func mapButtonClicked(sender: BusinessesViewController) {
    var buttonTitle = self.navigationItem.rightBarButtonItem?.title
    
    if (buttonTitle == "Map"){
      buttonTitle = "List"
      UIView.transitionFromView(businessesTableView, toView: businessesMapView, duration: 1.0, options: [.TransitionFlipFromLeft, .ShowHideTransitionViews], completion: nil)
    } else {
      buttonTitle = "Map"
      UIView.transitionFromView(businessesMapView, toView: businessesTableView, duration: 1.0, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: nil)
    }
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: buttonTitle, style: .Plain, target: self, action: "mapButtonClicked:")
    
  }
  
  func searchForBusinessesWithFilter(filter: Filter) {
    
    Business.searchWithTerm("restaurants", sort: filter.sort, categories: filter.categories, deals: filter.deals, radius: filter.radius, limit: nil, offset: nil) { (businesses: [Business]!, error: NSError!) -> Void in
      if let error = error {
        print((error.localizedDescription))
      } else {
        self.businesses = businesses
        self.searchedBusinesses = businesses
        self.newBusinessCount = businesses.count
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.businessesTableView.reloadData()
          self.reloadMapData(self.searchedBusinesses)
        })
      }
    }
  }
  
  func loadMorePagesWithFilter(filter: Filter) {
    
    newBusinessCount = businesses.count + 20
    Business.searchWithTerm("restaurants", sort: filter.sort, categories: filter.categories, deals: filter.deals, radius: filter.radius, limit: 20, offset: businesses.count) { (businesses: [Business]!, error: NSError!) -> Void in
      
      if let error = error {
        print((error.localizedDescription))
      } else {
        self.businesses?.appendContentsOf(businesses)
        self.searchedBusinesses = self.searchBusinessesWithSearchText(self.searchBar.text!)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.businessesTableView.reloadData()
          self.reloadMapData(self.searchedBusinesses)
        })
      }
    }
  }
  
  // MARK: - Helper
  
  func searchBusinessesWithSearchText(searchText: String) -> [Business] {
    
    var foundBusinesses: [Business]
    
    if searchText != "" {
      let pred =  NSPredicate(format: "name CONTAINS[c] %@", searchText)
      foundBusinesses = businesses.filter({ pred.evaluateWithObject($0)})
    } else {
      foundBusinesses = businesses
    }
    
    
    return foundBusinesses
  }
  
  func reloadMapData(businesses: [Business]){
    businessesMapView.removeAnnotations(businessesMapView.annotations)
    
    for business in businesses {
      if business.coordinate == nil {
        CLGeocoder().geocodeAddressString(business.geocodeAddress!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
          
          if let error = error{
            print((error.localizedDescription))
          }
          if let placemark = placemarks?[0] {
            business.placemark = placemark
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
              self.businessesMapView.addAnnotation(MKPlacemark(placemark: placemark))
            })
          }
        }
      } else {
        let annotation = MKPointAnnotation()
        annotation.coordinate = business.coordinate!
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.businessesMapView.addAnnotation(annotation)
        })
      }
    }
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == filtersViewSegueIdentifier {
      ((segue.destinationViewController as! UINavigationController).topViewController as! FiltersViewController).delegate = self
    } else if segue.identifier == detailsViewSegueIdentifier {
      let cell = sender as! BusinessTableViewCell
      let indexPath = businessesTableView.indexPathForCell(cell)
      let vc = segue.destinationViewController as! BusinessDetailViewController
      vc.businessID = searchedBusinesses[(indexPath?.row)!].id!
    }
  }
  
}

// MARK: - Delegate Methods

extension BusinessesViewController: FiltersViewControllerDelegate {
  func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filter: Filter) {
    searchForBusinessesWithFilter(filter)
    currentFilter = filter
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
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    businessesTableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
}

extension BusinessesViewController: UIScrollViewDelegate{
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if (maximumOffset - currentOffset) <= 1500 && (maximumOffset - currentOffset) >= -100 {
      if newBusinessCount == businesses.count && searchBar.text?.characters.count == 0 {
        loadMorePagesWithFilter(currentFilter)
      }
    }
  }
}

extension BusinessesViewController: UISearchResultsUpdating{
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchText = searchController.searchBar.text!
    
    if searchText.characters.count > 0 {
      searchedBusinesses = searchBusinessesWithSearchText(searchText)
    }
    businessesTableView.reloadData()
    reloadMapData(searchedBusinesses)
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
    reloadMapData(searchedBusinesses)
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

extension BusinessesViewController: MKMapViewDelegate {
  
  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    //    UIAlertView(title: "tapped Annotation!", message: view.annotation!.title!, delegate: nil, cancelButtonTitle: "OK").show()
  }
  
}
