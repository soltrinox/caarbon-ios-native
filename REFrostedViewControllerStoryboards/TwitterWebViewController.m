//
//  TwitterWebViewController.m
//  CELLO
//
//  Created by Dylan Rosario on 11/7/13.
//  Copyright (c) 2013 cello. All rights reserved.
//

#import "TwitterWebViewController.h"

@interface TwitterWebViewController ()

@end

@implementation TwitterWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor whiteColor];
	self.tweetLink = [[UIWebView alloc] initWithFrame:self.view.bounds];
	self.tweetLink.delegate = self;
	self.tweetLink.scalesPageToFit = YES;
	NSURL *url = [NSURL URLWithString:self.tweetURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.tweetLink loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
