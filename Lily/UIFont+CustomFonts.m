//
//  UIFont+CustomFonts.m
//  Lily
//
//  Created by David Richardson on 11/13/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "UIFont+CustomFonts.h"

@implementation UIFont (CustomFonts)

+ (UIFont *)helvetica14{
	return [UIFont fontWithName:@"Helvetica-Light" size:14];
}

+ (UIFont *)helveticaBold13{
	return [UIFont fontWithName:@"Helvetica-Bold" size:13];
}
+ (UIFont *)helveticaBold14{
	return [UIFont fontWithName:@"Helvetica-Bold" size:14];
}

+ (UIFont *)helvetica20{
	return [UIFont fontWithName:@"Helvetica-Light" size:16];
}

+ (UIFont *)helveticaBold32{
	return [UIFont fontWithName:@"Helvetica-Bold" size:30];
}

@end
