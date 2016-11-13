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
    
    if([pageType isEqualToString:@"About"]){
        contentText = [self aboutContent];
    }
    else if([pageType isEqualToString:@"Licenses"]){
        contentText = [self licensesContent];
    }
    
    return contentText;
    
}

- (NSAttributedString *)helpContent{
    
    // make content
    NSMutableString *content = [[NSMutableString alloc] init];
    
    // login
    [content appendString:@"\nLogin\n\n"];
    [content appendString:@"Lily operates by contacting Venmo's servers and retrieving your account information. With that information, we can analyze your data and give you insights into your financial habits. To make this possible, you need to authenticate your account at the login screen. This is accomplished by:\n\n"];
    [content appendString:@"1) Entering your Venmo credentials\n\n"];
    [content appendString:@"2) Hitting \"Send Code\"\n\n"];
    [content appendString:@"3) Entering the verification code sent to your code\n\n"];
    
    // dashboard
    [content appendString:@"\nDashboard\n\n"];
    [content appendString:@"The dashboard is the first screen that appears after you login to Lily. It contains a list of the available analysis options for your Venmo transactions. There are 6 options available that fall under 2 categories:\n\n"];
    [content appendString:@"1) Friends - this section analyzes who you interact with the most and the least on Venmo.\n\n"];
    [content appendString:@"2) This Year - this section analyzes your financial habits on a month-by-month basis\n\n"];
    
    // graphs
    [content appendString:@"\nGraphs\n\n"];
    [content appendString:@"After selecting one of the analysis options, you will be taken to a screen containing a graphical display of your financial habits. There are 3 possible displays:\n\n"];
    [content appendString:@"1) Bar Chart - this is a simple bar chart that can be found under \"Friends:transactions\" and \"This Year:expenditures\"\n"];
    [content appendString:@"Initially, the chart will only display a few values on the X-axis (this is to avoid clutter). By pinching to zoom, you can get a more detailed view of the data. Moreover, you can tap on any bar in the graph and view that entry's data.\n\n"];
    [content appendString:@"2) Bar (+/-) Chart - this is a bar chart displaying positive and negative values that can be found under \"Friends:net income\" and \"This Year:net income\"\n"];
    [content appendString:@"Similar to (1), initially, the chart will only display a few values on the X-axis (this is to avoid clutter). By pinching to zoom, you can get a more detailed view of the data. Moreover, you can tap on any bar in the graph and view that entry's data.\n\n"];
    [content appendString:@"3) List View - this is a page displaying detailed information on given data, in a list form. It can be found under \"Friends:full details\" and \"This Year:full details\"\n"];
    [content appendString:@"Interact with this form of data simply by swiping up and down the screen, observing the values displayed.\n\n"];
    
    // transactions
    [content appendString:@"\nTransactions\n\n"];
    [content appendString:@"The second tab at the bottom of the screen is the transactions tab. This page contains information on all your transactions that have been fetched from Venmo's servers. They are organized by date and contain information on who you made the transaction with, the dollar amount of the transaction, and the transaction's description.\n"];

    
    // attribute content
    NSMutableAttributedString *attributedContent = [[NSMutableAttributedString alloc] initWithString:content];
    
    // attributes
    NSArray *words = @[@"Login", @"Dashboard", @"Graphs", @"Transactions"];
    
    for(NSString *word in words){
        NSRange range = [content rangeOfString:word];
        [attributedContent addAttribute:NSFontAttributeName
                                  value:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]
                                  range:range];
    }
    
    
    return attributedContent;
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
