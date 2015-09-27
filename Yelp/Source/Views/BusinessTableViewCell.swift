//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Randy Ting on 9/22/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
  
  @IBOutlet weak var businessImage: UIImageView!
  @IBOutlet weak var businessNameLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var ratingImage: UIImageView!
  @IBOutlet weak var numberOfReviewsLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var categoriesLabel: UILabel!
  
  var business: Business! {
    didSet {
      businessImage.setImageWithURL(business.imageURL)
      businessNameLabel.text = business.name
      distanceLabel.text = business.distance
      ratingImage.setImageWithURL(business.ratingImageURL)
      addressLabel.text = business.address
      categoriesLabel.text = business.categories
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    businessImage.layer.cornerRadius = 5.0
    businessImage.clipsToBounds = true
    
    layoutMargins = UIEdgeInsetsZero
    separatorInset = UIEdgeInsetsZero
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
