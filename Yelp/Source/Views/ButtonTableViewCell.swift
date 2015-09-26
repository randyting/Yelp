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
  @IBOutlet weak var buttonTopToContentViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonBottomToContentViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!

  
  var shouldCollapse: Bool = true{
    didSet {
      if shouldCollapse {
        collapse()
      } else {
        expand()
      }
    }
  }
  
  var on: Bool! {
    didSet {
      if (on != nil) && on == true {
        buttonButton.tintColor = UIColor.blueColor()
      } else {
        buttonButton.tintColor = UIColor.lightGrayColor()
        
      }
    }
  }
  
  func collapse() {
    buttonTopToContentViewConstraint.constant = 0
    buttonBottomToContentViewConstraint.constant = 0
    buttonHeightConstraint.constant = 0
  }
  
  func expand() {
    buttonTopToContentViewConstraint.constant = 10
    buttonBottomToContentViewConstraint.constant = 10
    buttonHeightConstraint.constant = 30
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = UITableViewCellSelectionStyle.None
    
    layoutMargins = UIEdgeInsetsZero
    separatorInset = UIEdgeInsetsZero
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  override func prepareForReuse() {
    self.buttonLabel.text = ""
    self.buttonButton.titleLabel!.text = ""
    self.textLabel?.text = ""
    
  }
  
}
