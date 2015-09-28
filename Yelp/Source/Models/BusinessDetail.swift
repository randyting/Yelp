//
//  BusinessDetail.swift
//  Yelp
//
//  Created by Randy Ting on 9/27/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessDetail: NSObject {
  
  var id: String?
  var name: String?
  var imageUrl: String?
  var snippetText: String?
  var snippetImageUrl: NSURL?
  
  var reviewExcerpt: String?
  var reviewerName: String?
  var reviewerImageUrl: NSURL?
  
  init(dictionary: [String: AnyObject]) {
    id = dictionary["id"] as? String
    name = dictionary["name"] as? String
    imageUrl = dictionary["image_url"] as? String
    
    let location = dictionary["location"] as? NSDictionary
    var address = ""
    if location != nil {
      let addressArray = location!["display_address"] as? NSArray
      for field in addressArray! {
        address += (field as! String) + ", "
      }
    }
    snippetText = address
    
    let snippetImageURLString = dictionary["image_url"] as? String
    if snippetImageURLString != nil {
      snippetImageUrl = NSURL(string: snippetImageURLString!)!
      print((snippetImageUrl))
    } else {
      snippetImageUrl = nil
    }
    
    let reviews = dictionary["reviews"] as? NSArray
    if reviews != nil {
      let reviewDictionary = reviews![0] as? NSDictionary
      self.reviewExcerpt = reviewDictionary!["excerpt"] as? String
      self.reviewerName = (reviewDictionary!["user"] as? NSDictionary)!["name"] as? String
      let reviewerImageURLString = (reviewDictionary!["user"] as? NSDictionary)!["image_url"] as? String
      if reviewerImageURLString != nil {
        reviewerImageUrl = NSURL(string: reviewerImageURLString!)!
      } else {
        reviewerImageUrl = nil
      }
      
    }

  }
  
  class func getDetailsForBusinessID(id: String, completion: ([String: AnyObject]!, NSError!) -> Void) {
    YelpClient.sharedInstance.retrieveBusinessDetailsForID(id, completion: completion)
  }
  
}

