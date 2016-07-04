//
//  DPRImageTansformer.m
//  Lily
//
//  Created by David Richardson on 6/28/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "DPRImageTansformer.h"
#import <UIKit/UIKit.h>

@implementation DPRImageTansformer

// transforming to NSData class
+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    
    if(!value) {
        return nil;
    }
    
    if([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
    
}

- (id)reverseTransformedValue:(id)value {
    
    return [UIImage imageWithData:value];
    
}

@end
