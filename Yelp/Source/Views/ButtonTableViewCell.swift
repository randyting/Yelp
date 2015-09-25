//
//  ButtonTableViewCell.swift
//  Yelp
//
//  Created by Randy Ting on 9/24/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
  
  @IBOutlet weak var buttonLabel: UILabel!
  @IBOutlet weak var buttonButton: UIButton!
  
  var on: Bool! {
    didSet {
      if (on != nil) && on == true {
        buttonButton.tintColor = UIColor.blueColor()
      } else {
        buttonButton.tintColor = UIColor.lightGrayColor()
        
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layoutMargins = UIEdgeInsetsZero
    separatorInset = UIEdgeInsetsZero
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    self.buttonLabel.text = ""
  }
  
}
