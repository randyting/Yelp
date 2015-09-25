//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

// MARK: - Protocol

@objc protocol FiltersViewControllerDelegate {
  
  optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filter: Filter)
  
}

class FiltersViewController: UIViewController {
  
  // MARK: - Constants
  
  let switchCellReuseIdentifier = "com.randy.SwitchCell"
  let buttonCellReuseIdentifier = "com.randy.ButtonCell"
  let categoriesJsonURL = NSURL(string: "https://s3-media2.fl.yelpcdn.com/assets/srv0/developer_pages/5e749b17ad6a/assets/json/categories.json")
  let defaultsKeyForSwitchStates = "com.randy.defaultsKeyForSwitchStates"
  
  // MARK: - Storyboard Objects
  
  @IBOutlet weak var filtersTableView: UITableView!
  
  // MARK: - Properties
  
  weak var delegate: FiltersViewControllerDelegate?
  var categories = [[String:String]]()
  var filter = Filter()
  var switchStates: [NSIndexPath:Bool]?
  
  // MARK: - Lifecycle
  
  override func loadView() {
    super.loadView()
    
    setupNavigationBar()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadPersistentData()
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
  
  func loadPersistentData() {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let switchStates = defaults.objectForKey(defaultsKeyForSwitchStates){
      let switchStatesData = NSKeyedUnarchiver.unarchiveObjectWithData(switchStates as! NSData) as? [NSIndexPath: Bool]
      self.switchStates = switchStatesData
    } else {
      self.switchStates = [NSIndexPath:Bool]()
    }
    defaults.synchronize()
  }
  
  func savePersistentData() {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(switchStates!) , forKey: defaultsKeyForSwitchStates)
    defaults.synchronize()
  }
  
  // MARK: - Behavior
  
  func onCancelButtonTapped(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true) { () -> Void in
      // Do nothing
    }
  }
  
  func onSearchButtonTapped(sender: UIBarButtonItem) {
    
    filter.categories = getSelectedCategoriesForSwitchStates(switchStates!)
    filter.sort = getSelectedSortByForSwitchStates(switchStates!)
    filter.deals = getSelectedDealsFilterForSwitchStates(switchStates!)
    savePersistentData()
    
    delegate?.filtersViewController?(self, didUpdateFilters: filter)
    self.dismissViewControllerAnimated(true) { () -> Void in
      // Do nothing
    }
    
  }
  
  @IBAction func buttonPressed(sender: UIButton) {
    let selectedIndexPath = filtersTableView.indexPathForCell(sender.superview?.superview as! UITableViewCell)
    
    if switchStates![selectedIndexPath!] == nil {
      for var row = 0; row < filtersTableView.numberOfRowsInSection((selectedIndexPath?.section)!); row++ {
        let modifyingIndexPath = NSIndexPath(forRow: row, inSection: (selectedIndexPath?.section)!)
        switchStates![modifyingIndexPath] = false
      }
    }
    
    for (indexPath, _) in switchStates! {
      if indexPath.section == selectedIndexPath?.section{
        if indexPath.row == selectedIndexPath?.row {
          switchStates![indexPath] = true
                  print((indexPath.row))
        } else {
          switchStates![indexPath] = false
        }

      }
    }
    
    
    filtersTableView.reloadData()
    
  }
  
  
  // MARK: - Helper
  
  func getSelectedCategoriesForSwitchStates(switchStates: [NSIndexPath:Bool]) -> [String] {
    var categoriesToFilter = [String]()
    for (indexPath, state) in switchStates {
      if (indexPath.section == FiltersSection.Categories.rawValue){
        if state {
          categoriesToFilter.append(categories[indexPath.row]["code"]!)
        }
      }
    }
    return categoriesToFilter
  }
  
  func getSelectedSortByForSwitchStates(switchStates: [NSIndexPath:Bool]) -> YelpSortMode {
    var sortMode = YelpSortMode.BestMatched
    
    for (indexPath, state) in switchStates {
      if (indexPath.section == FiltersSection.SortBy.rawValue){
        if state {
          sortMode = YelpSortMode(rawValue: indexPath.row)!
        }
      }
    }
  
    return sortMode
  }
  
  func getSelectedDealsFilterForSwitchStates(switchStates: [NSIndexPath:Bool]) -> Bool? {
    
    return switchStates[NSIndexPath(forRow: 0, inSection: FiltersSection.Deals.rawValue)]!
    
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
      return YelpSortMode.count.rawValue
    case .Categories:
      return categories.count
    case .count:
      assert(true, "Attempted to access FiltersSection out of bounds.")
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch FiltersSection(rawValue: indexPath.section)! {
    case .Deals:
      let cell = filtersTableView.dequeueReusableCellWithIdentifier(switchCellReuseIdentifier, forIndexPath: indexPath) as! SwitchTableViewCell
      cell.switchLabel.text = "deals"
      cell.selectSwitch.on = switchStates?[indexPath] ?? false
      return cell
    case .Distance:
      let cell = filtersTableView.dequeueReusableCellWithIdentifier(buttonCellReuseIdentifier, forIndexPath: indexPath) as! ButtonTableViewCell
      cell.buttonLabel.text = "distance"
      return cell
    case .SortBy:
      let cell = filtersTableView.dequeueReusableCellWithIdentifier(buttonCellReuseIdentifier, forIndexPath: indexPath) as! ButtonTableViewCell
      cell.buttonLabel.text = YelpSortMode(rawValue: indexPath.row)?.title()
      cell.on = switchStates?[indexPath] ?? false
      return cell
    case .Categories:
      let cell = filtersTableView.dequeueReusableCellWithIdentifier(switchCellReuseIdentifier, forIndexPath: indexPath) as! SwitchTableViewCell
      cell.selectSwitch.on = switchStates?[indexPath] ?? false
      cell.switchLabel.text = categories[indexPath.row]["name"]
      cell.delegate = self
      return cell
    case .count:
      let cell = filtersTableView.dequeueReusableCellWithIdentifier(switchCellReuseIdentifier, forIndexPath: indexPath) as! SwitchTableViewCell
      assert(true, "Attempted to access FiltersSection out of bounds.")
      return cell
    }
    
  }
  
}

// MARK: - Types

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


// MARK: - Delegate Methods

extension FiltersViewController: SwitchTableViewCellDelegate {
  func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, switchValueChangedTo: Bool) {
    let indexPath = filtersTableView.indexPathForCell(switchTableViewCell)
    
    switchStates![indexPath!] = switchValueChangedTo
  }
}