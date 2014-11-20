//
//  ADGBubble.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 09/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGBubble.h"
#import "ADGConstants.h"

@interface ADGBubble ()

@end

@implementation ADGBubble


-(instancetype)init
{
    self = [super initWithImageNamed:@"Bubble"];
    
    if (self)
    {
        //Setup physics body
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = kADGBubbleCategory;
        self.physicsBody.contactTestBitMask = kADGFanCategory | kADGSpikyBallCategory;
    }
    
    return self;
}

-(void)applyForce:(DirectionForce)direction
{
    if (direction == ApplyLeft)
    {
        [self.physicsBody applyForce:CGVectorMake(-10, 0)];
    }
    else if (direction == ApplyRight)
    {
        [self.physicsBody applyForce:CGVectorMake(10, 0)];
    }
}

-(void)bubbleBurst:(SKPhysicsBody *)contactBody
{
    if (!self.bubbleBurst)
    {
        if (contactBody.categoryBitMask == kADGFanCategory)
        {
            //Bubble has hit a fan
            self.bubbleBurst = YES;
            [self removeFromParent];
        }
        else if (contactBody.categoryBitMask == kADGSpikyBallCategory)
        {
            self.bubbleBurst = YES;
            [self removeFromParent];
        }
    }
}

@end
