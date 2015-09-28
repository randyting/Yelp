//
//  CarouselReviewView.swift
//  Yelp
//
//  Created by Randy Ting on 9/27/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

import UIKit

class CarouselReviewView: UIView {

  @IBOutlet var contentView: UIView!

  @IBOutlet weak var reviewExcerptLabel: UILabel!

  @IBOutlet weak var reviewerName: UILabel!
  @IBOutlet weak var reviewerProfileImage: UIImageView!
  
  @IBOutlet weak var snippetImage: UIImageView!
  @IBOutlet weak var snippetText: UILabel!
  @IBOutlet weak var businessName: UILabel!
  
  @IBOutlet weak var transparentBackground: UIView!
  
  override init(frame: CGRect) { // for using CustomView in code
    super.init(frame: frame)
    self.commonInit()
  }
  
  required init(coder aDecoder: NSCoder) { // for using CustomView in IB
    super.init(coder: aDecoder)!
    self.commonInit()
  }
  
  private func commonInit() {
    NSBundle.mainBundle().loadNibNamed("CarouselReviewView", owner: self, options: nil)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    self.addSubview(contentView)
  }
  
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
