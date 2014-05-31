//
//  TwitterWebViewController.h
//  CELLO
//
//  Created by Dylan Rosario on 11/7/13.
//  Copyright (c) 2013 cello. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *tweetLink;
@property (nonatomic, strong) NSString *tweetURL;

@end
