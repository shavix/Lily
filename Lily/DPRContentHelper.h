//
//  DPRContentHelper.h
//  Lily
//
//  Created by David Richardson on 10/30/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPRContentHelper : NSObject

// methods
- (NSString *)contentTextWithPageType:(NSString *)pageType;
- (NSAttributedString *)helpContent;

@end
