//
//  ADGBubble.h
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 09/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    ApplyLeft,
    ApplyRight,
    ApplyNone,
} DirectionForce;

@interface ADGBubble : SKSpriteNode

@property (nonatomic) BOOL bubbleBurst;


-(void)applyForce:(DirectionForce)direction;
-(void)bubbleBurst:(SKPhysicsBody *)contactBody;


@end
