//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Randy Ting on 9/27/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessDetailViewController: UIViewController {
  
  @IBOutlet weak var carousel: iCarousel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
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

//extension BusinessDetailViewController: iCarouselDelegate, iCarouselDataSource {
//  func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
//    <#code#>
//  }
//  
//  func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
//    <#code#>
//  }
//}
