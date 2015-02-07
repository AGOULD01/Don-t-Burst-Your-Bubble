//
//  ADGMoleyBabies.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 20/01/2015.
//  Copyright (c) 2015 Adam Gould. All rights reserved.
//

#import "ADGMoleyBabies.h"
#import "ADGConstants.h"

@implementation ADGMoleyBabies

-(instancetype)init
{
    if (self == [super initWithImageNamed:@"MoleyResting"])
    {
        self.size = CGSizeMake(self.size.width * 0.5, self.size.height * 0.5);
        self.name = @"MoleyBabies";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = kADGMoleyBabyCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

-(void)babyMoleyHit:(SKPhysicsBody *)contactBody
{
    if (contactBody.categoryBitMask == kADGSpikyBallCategory)
    {
        [self removeAllActions];
        [self removeFromParent];
    }
}


@end
