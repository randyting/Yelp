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
  
  
  
  init(dictionary: [String: AnyObject]) {
    id = dictionary["id"] as? String
    name = dictionary["name"] as? String
    imageUrl = dictionary["image_url"] as? String
  }
  
  class func getDetailsForBusinessID(id: String, completion: ([String: AnyObject]!, NSError!) -> Void) {
    YelpClient.sharedInstance.retrieveBusinessDetailsForID(id, completion: completion)
  }
  
}
