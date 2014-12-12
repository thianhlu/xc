//
//  StoryTableViewCell.h
//  xcode-practice
//
//  Created by Thianh Lu on 11/17/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryTableViewCell;
@protocol StoryTableViewCellDelegate <NSObject>

- (void)storyTableViewCell:(StoryTableViewCell *)cell upvoteButtonDidPress:(id)sender;

@end

@interface StoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *upvoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upvoteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) id<StoryTableViewCellDelegate> delegate;
@property (nonatomic) BOOL isUpvoted;
- (IBAction)upvoteButtonDidPress:(id)sender;
- (IBAction)commentButtonDidPress:(id)sender;

@end
