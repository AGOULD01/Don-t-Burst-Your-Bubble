//
//  ADGScrollingNode.h
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 23/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ADGScrollingNode : SKNode

@property (nonatomic) CGFloat verticalScrollSpeed;

- (void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed;

@end
