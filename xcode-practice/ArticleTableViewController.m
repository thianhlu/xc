//
//  ArticleTableViewController.m
//  xcode-practice
//
//  Created by Thianh Lu on 11/25/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import "ArticleTableViewController.h"
#import "StoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"
#import "WebViewController.h"
#import "xcode-practice-api.h"

@interface ArticleTableViewController () <StoryTableViewCellDelegate>

@end

@implementation ArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Testing data
    NSLog(@"Test Story%@", self.story);
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [[self.story valueForKeyPath:@"comments"] count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell Identifer
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    StoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    
    //set delegate in cellForRowAtIndexPath
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell Identifer
    NSString *cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    StoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell forIndexPath:indexPath];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Change the cell height
    return height+1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When user selects a row
    NSString *fullURL = [self.story valueForKey:@"url"];
    if(indexPath.row == 0) {
        // Perform segue if first row
        [self performSegueWithIdentifier:@"articleToWebScene" sender:fullURL];
    }
}


#pragma mark - Private methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"articleToWebScene"]) {
        WebViewController *controller = segue.destinationViewController;
        controller.fullURL = sender;
    }
}


-(NSString *)cellIdentifierForIndexPath: (NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return @"storyCell";
    }
    return @"commentCell";
}

-(void)configureCell: (StoryTableViewCell *)cell forIndexPath: (NSIndexPath *)indexPath
{
    // If first row
    if(indexPath.row == 0) {
        
        // Values
        NSDictionary *story = self.story;
        
        cell.titleLabel.text = [story valueForKeyPath:@"title"];
        
        // If not Null
        if([story valueForKey:@"user_job"] != [NSNull null]) {
            cell.authorLabel.text = [NSString stringWithFormat:@"%@, %@", [story valueForKey:@"user_display_name"], [story valueForKey:@"user_job"]];
        }
        else {
            cell.authorLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"user_display_name"]];
        }
        
        cell.commentLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"comment_count"]];
        cell.upvoteLabel.text = [NSString stringWithFormat:@"%@", [story valueForKey:@"vote_count"]];
        
        // Image from Web
        [cell.avatarImageView sd_setImageWithURL:[story valueForKeyPath:@"user_portrait_url"]];
        
        // Simple date
        NSString* strDate = [story objectForKey:@"created_at"];
        NSDate *time = [self dateWithJSONString:strDate];
        cell.timeLabel.text = [time timeAgoSimple];
        NSLog(@"%@", [time timeAgoSimple]);
        
        //Comment
        cell.descriptionLabel.text = [story valueForKeyPath:@"comment"];
        
        // Reset when cells are re-rendered
        // Change button image
        cell.upvoteImageView.image = [UIImage imageNamed:@"icon-upvote"];
        // Change text color
        cell.upvoteLabel.textColor = [UIColor colorWithRed:0.627 green:0.69 blue:0.745 alpha:1];
        // Toggle
        cell.isUpvoted = NO;
        
        // If upvoted
        [DNUser isUpvotedWithStory:story completion:^(BOOL succeed, NSError *error) {
            // Change button image
            cell.upvoteImageView.image = [UIImage imageNamed:@"icon-upvote-active"];
            // Change text color
            cell.upvoteLabel.textColor = [UIColor colorWithRed:0.203 green:0.329 blue:0.835 alpha:1];
            //Toggle
            cell.isUpvoted = YES;
        }];

    }
    else {
        // Values
        NSDictionary *comment = self.story[@"comments"][indexPath.row-1];
        
        // If not Null
        if([comment valueForKey:@"user_job"] != [NSNull null]) {
            cell.authorLabel.text = [NSString stringWithFormat:@"%@, %@", [comment valueForKey:@"user_display_name"], [comment valueForKey:@"user_job"]];
        }
        else {
            cell.authorLabel.text = [NSString stringWithFormat:@"%@", [comment valueForKey:@"user_display_name"]];
        }
        
        cell.commentLabel.text = @"Reply";
        cell.upvoteLabel.text = [NSString stringWithFormat:@"%@", [comment valueForKey:@"vote_count"]];
        
        // Simple date
        NSString* strDate = [comment objectForKey:@"created_at"];
        NSDate *time = [self dateWithJSONString:strDate];
        cell.timeLabel.text = [time timeAgoSimple];
        
        // Comment
        cell.descriptionLabel.text = [comment valueForKeyPath:@"body"];

    }
}


- (NSDate*)dateWithJSONString:(NSString*)dateStr
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // This is for check the output
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"]; // Here you can change your require output date format EX. @"EEE, MMM d YYYY"
    dateStr = [dateFormat stringFromDate:date];
    
    return date;
}

#pragma mark StoryTableViewCellDelegate

- (void)storyTableViewCell:(StoryTableViewCell *)cell upvoteButtonDidPress:(id)sender
{
    // Get indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // Get data from the array at position of the row
    NSDictionary *story = self.story;
    
    // Only do API upvote is story hasnt been upvoted
    if(!cell.isUpvoted){
        // Change button image
        cell.upvoteImageView.image = [UIImage imageNamed:@"icon-upvote-active"];
        // Change text color
        cell.upvoteLabel.textColor = [UIColor colorWithRed:0.203 green:0.329 blue:0.835 alpha:1];
        //Toggle
        cell.isUpvoted = YES;
        
        // Pop animation
        UIImageView *view = cell.upvoteImageView;
        NSTimeInterval duration = 0.5;
        NSTimeInterval delay = 0;
        [UIView animateKeyframesWithDuration:duration/3 delay:delay options:0 animations:^{
            // End
            view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
                // End
                view.transform = CGAffineTransformMakeScale(0.7, 0.7);
            } completion:^(BOOL finished) {
                [UIView animateKeyframesWithDuration:duration/3 delay:0 options:0 animations:^{
                    // End
                    view.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
            }];
        }];
        
        //story only
        if(indexPath == 0 ){
            // Increment number
            int upvoteInt = [[story valueForKey:@"vote_count"] intValue] +1;
            cell.upvoteLabel.text = [NSString stringWithFormat:@"%d", upvoteInt];
            
            // Do API Post
            [DNAPI upvoteWithStory:story];
            
            // Save to Keychain
            [DNUser saveUpvoteWithStory:story];
        }
    }
}

@end
