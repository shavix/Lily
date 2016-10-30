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
    
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendString:@"Help"];
    
    return content;
}

- (NSString *)aboutContent{
    
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendString:@"2016 David Richardson\n"];
    [content appendString:@"Software engineer, USC graduate."];

    return content;
}

- (NSString *)licensesContent{
    
    // MIT license
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MITLicense" ofType:@"txt"];
    NSString *MITLicense = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    // apache license
    path = [[NSBundle mainBundle] pathForResource:@"ApacheLicense" ofType:@"txt"];
    NSString *apacheLicense = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendString:@"\nImages\n\n"];
    [content appendString:@"Madebyoliver: Presentation\n"];
    [content appendString:@"Madebyoliver: Graph\n"];
    [content appendString:@"Madebyoliver: Info\n"];
    [content appendString:@"Madebyoliver: Financials\n"];
    [content appendString:@"Freepik: Athletics\n"];
    [content appendString:@"Freepik: Agreement\n"];
    [content appendString:@"Freepik: Businessman\n"];
    [content appendString:@"Freepik: Lily\n"];
    [content appendString:@"Freepik: Bonusprofit\n"];
    [content appendString:@"Freepik: Cashpayment\n"];
    [content appendString:@"Freepik: Fiscalyear\n"];
    [content appendString:@"Freepik: Taxform\n"];
    [content appendString:@"Roundicons: Free\n"];
    [content appendString:@"Roundicons: Info\n"];
    [content appendString:@"\n----------------\n"];
    [content appendString:@"\nSoftware: EAIntroView\n"];
    [content appendString:@"Copyright (c) 2013-2015 Evgeny Aleksandrov\n\n"];
    [content appendString:MITLicense];
    [content appendString:@"\n----------------\n"];
    [content appendString:@"\nSoftware: SDWebImage\n"];
    [content appendString:@"Copyright (c) 2016 Olivier Poitrey rs@dailymotion.com\n\n"];
    [content appendString:MITLicense];
    [content appendString:@"\n----------------\n"];
    [content appendString:@"\nSoftware: iOS Charts\n"];
    [content appendString:@"\nCopyright 2016 Daniel Cohen Gindi & Philipp Jahoda\n\n"];
    [content appendString:apacheLicense];

   

    return content;
}

@end
