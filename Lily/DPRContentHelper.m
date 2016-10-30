//
//  DPRContentHelper.m
//  Lily
//
//  Created by David Richardson on 10/30/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRContentHelper.h"

@implementation DPRContentHelper

- (NSString *)contentTextWithPageType:(NSString *)pageType {
    
    NSString *contentText;
    
    if([pageType isEqualToString:@"Help"]){
        contentText = [self helpContent];
    }
    else if([pageType isEqualToString:@"About"]){
        contentText = [self aboutContent];
    }
    else if([pageType isEqualToString:@"Licenses"]){
        contentText = [self licensesContent];
    }
    
    return contentText;
    
}

- (NSString *)helpContent{
    
    NSString *content = @"help";
    
    return content;
}

- (NSString *)aboutContent{
    
    NSString *content = @"about";
    
    return content;
}

- (NSString *)licensesContent{
    
    NSString *content = @"licenses";
    
    return content;
}

@end
