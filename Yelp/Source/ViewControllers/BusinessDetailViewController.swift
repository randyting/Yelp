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
        self.carousel.reloadData()
      }
    }
  }
  
}

extension BusinessDetailViewController: iCarouselDelegate, iCarouselDataSource {
  func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
    var reviewView: CarouselReviewView
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
      reviewView = CarouselReviewView(frame:CGRect(x:0, y:0, width:super.view.frame.width-100, height:super.view.frame.height - 100))
    }
    else
    {
      reviewView = view as! CarouselReviewView
    }
    
    reviewView.reviewExcerptLabel.text = businessDetail?.reviewExcerpt
    reviewView.reviewerName.text = businessDetail?.reviewerName
    reviewView.reviewerProfileImage.setImageWithURL(businessDetail?.reviewerImageUrl)
    
    reviewView.snippetImage.setImageWithURL(businessDetail?.snippetImageUrl)
    reviewView.snippetText.text = businessDetail?.snippetText
    reviewView.businessName.text = businessDetail?.name
    
    switch index {
    case 0:
      reviewView.reviewExcerptLabel.hidden = true
      reviewView.reviewerName.hidden = true
      reviewView.reviewerProfileImage.hidden = true
      reviewView.snippetImage.hidden = false
      reviewView.snippetText.hidden = false
      reviewView.businessName.hidden = false
      reviewView.transparentBackground.hidden = false
    case 1:
      reviewView.reviewExcerptLabel.hidden = false
      reviewView.reviewerName.hidden = false
      reviewView.reviewerProfileImage.hidden = true
      reviewView.snippetImage.hidden = true
      reviewView.snippetText.hidden = true
      reviewView.businessName.hidden = true
      reviewView.transparentBackground.hidden = true
    case 2:
      reviewView.reviewExcerptLabel.hidden = true
      reviewView.reviewerName.hidden = true
      reviewView.reviewerProfileImage.hidden = false
      reviewView.snippetImage.hidden = true
      reviewView.snippetText.hidden = true
      reviewView.businessName.hidden = true
      reviewView.transparentBackground.hidden = true
    default: break
      
    }
    
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
