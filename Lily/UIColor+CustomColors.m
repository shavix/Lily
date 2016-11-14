//
//  UIColor+CustomColors.m
//  Lily
//
//  Created by David Richardson on 6/22/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)


+ (UIColor *)darkColor{
    
    return [UIColor colorWithRed:21.f/255.f green:23.f/255.f blue:28.f/255.f alpha:1.f];

}

+ (UIColor *)darkishColor{
    
    return [UIColor colorWithRed:30.f/255.f green:33.f/255.f blue:41.f/255.f alpha:1.f];

}

+ (UIColor *)charcoalColor {
    
    //return [UIColor colorWithRed:54.f/255.f green:69.f/255.f blue:79.f/255.f alpha:1.f];
    return [UIColor colorWithRed:42.f/255.f green:46.f/255.f blue:59.f/255.f alpha:1.f];

}

+ (UIColor *)lightGreenColor {
    
    return [UIColor colorWithRed:20.f/255.f green:205.f/255.f blue:130.f/255.f alpha:1.f];
    
}

+ (UIColor *)lightColor {
    
    return [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.f];
    
}

+ (UIColor *)chartGreen{
	
	return [UIColor colorWithRed:110/255.f green:190/255.f blue:102/255.f alpha:1.f];
	
}

+ (UIColor *)chartRed{
	
	return [UIColor colorWithRed:211/255.f green:74/255.f blue:88/255.f alpha:1.f];
	
}

+ (NSArray *)palet{
    
    NSArray *arr = [NSArray arrayWithObjects:
                    [UIColor colorWithRed:200.f/255.f green:0.f/255.f blue:0.f/255.f alpha:1.f],
                    [UIColor colorWithRed:0.f/255.f green:200.f/255.f blue:0.f/255.f alpha:1.f],
                    [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:200.f/255.f alpha:1.f],
                    [UIColor colorWithRed:0.f/255.f green:200.f/255.f blue:200.f/255.f alpha:1.f],
                    [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f],
                    nil];
    
    return arr;
    
}

@end
