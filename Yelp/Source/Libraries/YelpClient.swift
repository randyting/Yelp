//
//  YelpClient.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let yelpConsumerKey = "K883AFnd2W6CRQn5YMGG3A"
let yelpConsumerSecret = "vRMYNyZShBH6j8qdPBN0Yzcxty4"
let yelpToken = "tGzErRfzhc1PMyq5iJlskfuOTjCZB2mW"
let yelpTokenSecret = "IkbR3-i1PO2Su9qtGk44sSFZVOw"

enum YelpSortMode: Int {
  case BestMatched = 0, Distance, HighestRated, count
  
  static let titles = [
    BestMatched: "Best Matched",
    Distance: "Distance",
    HighestRated: "Highest Rated"
  ]
  
  func title() -> String {
    if let title = YelpSortMode.titles[self] {
      return title
    } else {
      assert(true, "Attempted to access YelpSortMode out of bounds.")
      return "Out of bounds"
    }
  }
}

class YelpClient: BDBOAuth1RequestOperationManager {
  var accessToken: String!
  var accessSecret: String!
  
  class var sharedInstance : YelpClient {
    struct Static {
      static var token : dispatch_once_t = 0
      static var instance : YelpClient? = nil
    }
    
    dispatch_once(&Static.token) {
      Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
    }
    return Static.instance!
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
    self.accessToken = accessToken
    self.accessSecret = accessSecret
    let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
    super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
    
    let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
    self.requestSerializer.saveAccessToken(token)
  }
  
  func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
    return searchWithTerm(term, sort: nil, categories: nil, deals: nil, completion: completion)
  }
  
  func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    
    // Default the location to San Francisco
    var parameters: [String : AnyObject] = ["term": term, "ll": "37.785771,-122.406165"]
    
    if sort != nil {
      parameters["sort"] = sort!.rawValue
    }
    
    if categories != nil && categories!.count > 0 {
      parameters["category_filter"] = (categories!).joinWithSeparator(",")
    }
    
    if deals != nil {
      parameters["deals_filter"] = deals!
    }
    
    print(parameters)
    
    return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
      let dictionaries = response["businesses"] as? [NSDictionary]
      if dictionaries != nil {
        completion(Business.businesses(array: dictionaries!), nil)
      }
      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        completion(nil, error)
    })
  }
}
