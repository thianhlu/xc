//
//  WebViewController.h
//  xcode-practice
//
//  Created by Thianh Lu on 12/1/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) NSString *fullURL;

@end
