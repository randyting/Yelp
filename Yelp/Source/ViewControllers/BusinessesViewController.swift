//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
  
  var businesses: [Business]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
    //            self.businesses = businesses
    //
    //            for business in businesses {
    //                println(business.name!)
    //                println(business.address!)
    //            }
    //        })
    
    Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
      self.businesses = businesses
      
      for business in businesses {
        print(business.name!)
        print(business.address!)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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
