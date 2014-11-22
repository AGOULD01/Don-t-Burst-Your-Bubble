//
//  ADGSpikyBalls.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 16/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGSpikyBalls.h"
#import "ADGConstants.h"

@implementation ADGSpikyBalls

-(instancetype)init
{
    self = [super initWithImageNamed:@"SpikyBall"];
    
    if (self)
    {
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.angularVelocity = 20.0;
        self.physicsBody.categoryBitMask = kADGSpikyBallCategory;
        self.physicsBody.collisionBitMask = 0;
        self.name = @"SpikyBallReleased";
    }
    
    return self;
}

@end
