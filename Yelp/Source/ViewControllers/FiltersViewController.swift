//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  
  optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters: [String:AnyObject])
  
}

class FiltersViewController: UIViewController {
  
  // MARK: - Constants
  
  let switchCellReuseIdentifier = "com.randy.SwitchCell"
  let categoriesJsonURL = NSURL(string: "https://s3-media2.fl.yelpcdn.com/assets/srv0/developer_pages/5e749b17ad6a/assets/json/categories.json")
  
  // MARK: - Storyboard Objects
  
  @IBOutlet weak var filtersTableView: UITableView!
  
  // MARK: - Properties
  
  weak var delegate: FiltersViewControllerDelegate?
  var categories = [[String:String]]()
  var filters = [String:AnyObject]()
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    setupNavigationBar()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView(filtersTableView)
    getRestaurantCategoriesfromJsonURL(categoriesJsonURL!)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Initialization
  
  func setupNavigationBar(){
    self.title = "Filter"
    navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .Plain, target: self, action: "onCancelButtonTapped:")
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Search", style: .Plain, target: self, action: "onSearchButtonTapped:")
  }
  
  func setupTableView(tableView: UITableView!) {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  func getRestaurantCategoriesfromJsonURL(categoriesJsonURL: NSURL){
    let request = NSURLRequest(URL: categoriesJsonURL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 0.0)
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
      if let error = error {
        print(error.localizedDescription)
      } else {
        let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSArray
        if let json = json {
          for category in json! {
            for parent in (category["parents"] as! NSArray) {
              if !parent.isKindOfClass(NSNull) && (parent as! String) == "restaurants"{
                let categoryToAdd = ["name":(category["title"] as! String), "code":(category["alias"] as! String)]
                self.categories.append(categoryToAdd)
              }
            }
          }
        }
        
      }
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.filtersTableView.reloadData()
      })
    }
    task.resume()
  }
  
  // MARK: - Behavior
  
  func onCancelButtonTapped(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true) { () -> Void in
      // Do nothing
    }
  }
  
  func onSearchButtonTapped(sender: UIBarButtonItem) {
    
    delegate?.filtersViewController?(self, didUpdateFilters: filters)
    self.dismissViewControllerAnimated(true) { () -> Void in
      // Do nothing
    }

  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  
  
}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return FiltersSection.count.rawValue
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return FiltersSection(rawValue: section)?.title()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch FiltersSection(rawValue: section)! {
    case .Deals:
      return 1
    case .Distance:
      return 1
    case .SortBy:
      return 1
    case .Categories:
      return categories.count
    case .count:
      assert(true, "Attempted to access FiltersSection out of bounds.")
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = filtersTableView.dequeueReusableCellWithIdentifier(switchCellReuseIdentifier, forIndexPath: indexPath)
    
    switch FiltersSection(rawValue: indexPath.section)! {
    case .Deals:
      cell.textLabel!.text = "deals"
    case .Distance:
      cell.textLabel!.text = "distance"
    case .SortBy:
      cell.textLabel!.text = "sortBy"
    case .Categories:
      cell.textLabel!.text = categories[indexPath.row]["name"]
    case .count:
      assert(true, "Attempted to access FiltersSection out of bounds.")
    }
    
    return cell
  }
  
}

extension FiltersViewController {
  
  enum FiltersSection : Int {
    case Deals, Distance, SortBy, Categories, count
    
    static let titles = [
      Deals: "Deals",
      Distance: "Distance",
      SortBy: "Sort By",
      Categories: "Categories"
    ]
    
    func title() -> String {
      if let title = FiltersSection.titles[self] {
        return title
      } else {
        assert(true, "Attempted to access FiltersSection out of bounds.")
        return "Out of bounds"
      }
    }
    
  }
}