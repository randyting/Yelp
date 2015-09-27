//
//  UIAppearance+Swift.h
//  Yelp
//
//  Created by Randy Ting on 9/27/15.
//  Copyright © 2015 Randy Ting. All rights reserved.
//

#ifndef UIAppearance_Swift_h
#define UIAppearance_Swift_h

@interface UIView (UIViewAppearance_Swift)
// appearanceWhenContainedIn: is not available in Swift. This fixes that.
+ (instancetype)my_appearanceWhenContainedIn:(Class<UIAppearanceContainer>)containerClass;
@end

#endif /* UIAppearance_Swift_h */
