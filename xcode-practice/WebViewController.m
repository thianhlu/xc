//
//  WebViewController.m
//  xcode-practice
//
//  Created by Thianh Lu on 12/1/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load web page
    //NSString *fullURL = @"http://designcode.io";
    NSURL *url = [NSURL URLWithString:self.fullURL];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [self.viewWeb loadRequest:requestObject];
}



@end
