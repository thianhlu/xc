//
//  StoryTableViewCell.m
//  xcode-practice
//
//  Created by Thianh Lu on 11/17/14.
//  Copyright (c) 2014 Thianh Lu. All rights reserved.
//

#import "StoryTableViewCell.h"

@implementation StoryTableViewCell

- (IBAction)upvoteButtonDidPress:(id)sender
{
    // Delegate method
    [self.delegate storyTableViewCell:self upvoteButtonDidPress:sender];
}

- (IBAction)commentButtonDidPress:(id)sender {
}


@end
