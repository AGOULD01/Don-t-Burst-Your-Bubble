//
//  ADGScrollingNode.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 23/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGScrollingNode.h"

@implementation ADGScrollingNode

-(void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    self.position = CGPointMake(self.position.x, self.position.y + (self.verticalScrollSpeed * timeElapsed));
}

@end
