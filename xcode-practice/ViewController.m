//
//  ViewController.m
//  xcode-practice
//
//  Created by Thianh ZOO on 10/31/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import "ViewController.h"
#import "xcode-practice-api.h"
#import "ACSimpleKeychain.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonDidPress:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // change status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // set delegates
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    // Add listener for textfield did change
    [self.emailTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)textFieldDidChange:(UITextField *)textField {
    if(textField.text.length > 20) {
        self.emailImageView.hidden = YES;
    }
    else {
        self.emailImageView.hidden = NO;
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //Highlight email text field
    NSLog(@"Hi, There");
    
    if ([textField isEqual:self.emailTextField]) {
        // Email
        [self.emailTextField setBackground:[UIImage imageNamed:@"input-outline-active"]];
        self.emailImageView.image = [UIImage imageNamed:@"icon-mail-active"];
    } else {
        [self.emailTextField setBackground:[UIImage imageNamed:@"input-outline"]];
        self.emailImageView.image = [UIImage imageNamed:@"icon-mail"];
    }
    
    //Highlight password field
    if ([textField isEqual:self.passwordTextField]) {
        // Pass
        [self.passwordTextField setBackground:[UIImage imageNamed:@"input-outline-active"]];
        self.passwordImageView.image = [UIImage imageNamed:@"icon-password-active"];
    } else {
        [self.passwordTextField setBackground:[UIImage imageNamed:@"input-outline"]];
        self.passwordImageView.image = [UIImage imageNamed:@"icon-password"];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // Reset highlighting
    [self.emailTextField setBackground:[UIImage imageNamed:@"input-outline"]];
    self.emailImageView.image = [UIImage imageNamed:@"icon-mail"];
    [self.passwordTextField setBackground:[UIImage imageNamed:@"input-outline"]];
    self.passwordImageView.image = [UIImage imageNamed:@"icon-password"];
}


-(void)doErrorMessage {
    [UIView animateWithDuration:0.1 animations:^{
        // Animate login button
        self.loginButton.transform = CGAffineTransformMakeTranslation(10, 0);
    } completion:^(BOOL finished) {
        //step 2
        [UIView animateWithDuration:0.1 animations:^{
            self.loginButton.transform = CGAffineTransformMakeTranslation(-10, 0);
        } completion:^(BOOL finished) {
            // step 3
            [UIView animateWithDuration:0.1 animations:^{
                self.loginButton.transform = CGAffineTransformMakeTranslation(0, 0);
            }];
        }];
    }];
    
    // Animate with duration with damping
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:0 animations:^{
        
        //make sure it runs only once and make dialog larger
        if(self.dialogView.frame.origin.y == 144) {
            [self.dialogView setFrame:CGRectMake(self.dialogView.frame.origin.x, self.dialogView.frame.origin.y-60, self.dialogView.frame.size.width, 320)];
        }
        
        
    } completion:^(BOOL finished) {}];
}

- (IBAction)loginButtonDidPress:(id)sender {
    
    // Show loading
    self.loadingView.hidden = NO;
    
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSDictionary *param = @{@"grant_type":@"password",
                            @"username":email,
                            @"password":password,
                            @"client_id":@"750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d",
                            @"client_secret":@"53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
                            };
    NSURLRequest *request = [NSURLRequest postRequest:DNAPILogin
                                           parameters:param];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSError *serializeError;
                                            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializeError];
                                            double delayInSeconds = 1.0f;   // Just for debug
                                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                
                                                // Hide loading
                                                self.loadingView.hidden = YES;
                                                
                                                // Get response
                                                self.data = json;
                                                NSString *token = [self.data valueForKeyPath:@"access_token"];
                                                NSLog(@"%@", self.data);
                                                
                                                // If logged
                                                if(token) {
                                                    // Do something after logged
                                                    NSLog(@"I am logged!");
                                                    
                                                    // Dismiss Modal
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                    // Save DN token
                                                    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
                                                    if ([keychain storeUsername:@"token" password:@"" identifier:token forService:@"DN"]) {
                                                        NSLog(@"Saved token");
                                                    }
                                                }
                                                else {
                                                    [self doErrorMessage];
                                                }
                                                
                                            });
                                        }];
    [task resume];
}
@end