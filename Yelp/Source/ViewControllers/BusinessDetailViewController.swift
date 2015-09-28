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
  
  var businessID: String?
  var businessDetail: BusinessDetail?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    carousel.type = .CoverFlow2
    carousel.delegate = self
    carousel.dataSource = self
    
    BusinessDetail.getDetailsForBusinessID(businessID!) { (details: [String : AnyObject]!, error: NSError!) -> Void in
      if let error = error {
        print((error.localizedDescription))
      } else {
        self.businessDetail = BusinessDetail(dictionary: details)
        print((self.businessDetail?.reviewExcerpt))
        self.carousel.reloadData()
      }
    }
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

extension BusinessDetailViewController: iCarouselDelegate, iCarouselDataSource {
  func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
    var reviewView: CarouselReviewView
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
      reviewView = CarouselReviewView(frame:CGRect(x:0, y:0, width:super.view.frame.width-100, height:super.view.frame.height - 100))
      
//      if let reviewExcerpts = businessDetail?.reviewExcerpts {
//        reviewView.reviewExcerptLabel.text = reviewExcerpts[index]
//      }
    }
    else
    {
      reviewView = view as! CarouselReviewView
    }
    
    reviewView.reviewExcerptLabel.text = businessDetail?.reviewExcerpt
    reviewView.ReviewerName.text = businessDetail?.reviewerName
    
    return reviewView
  }
  
  func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
    return 3
  }
  
  func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
  {
    if (option == .Spacing)
    {
      return value * 1.1
    }
    return value
  }
}
