//
//  ADGMoley.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 18/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGMoley.h"
#import "ADGSpikyBalls.h"
#import "ADGConstants.h"

@interface ADGMoley ()

@property (nonatomic) SKSpriteNode *spikyBall;

@end

@implementation ADGMoley

-(instancetype)init
{
    self = [super initWithImageNamed:@"MoleyResting"];
    
    if (self)
    {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = kADGMoleyCategory;
        self.physicsBody.collisionBitMask = kADGBubbleCategory;
        
        SKAction *throw = [SKAction sequence:@[[SKAction waitForDuration:0.5 withRange:1], [SKAction performSelector:@selector(throw) onTarget:self]]];
        [self runAction:[SKAction repeatActionForever:throw]];
        
    }
    
    return self;
}

-(void)prepareBall:(ADGBubble *)bubble
{
    if (self.children.count == 0)
    {
        _spikyBall = [SKSpriteNode spriteNodeWithImageNamed:@"SpikyBall"];
        _spikyBall.name = @"SpikyBall";
        
        if (bubble.position.x > self.position.x)
        {
            self.texture = [SKTexture textureWithImageNamed:@"MoleyRight"];
            _spikyBall.position = CGPointMake(20, 30);
            [self addChild:_spikyBall];
        }
        else
        {
            self.texture = [SKTexture textureWithImageNamed:@"MoleyLeft"];
            _spikyBall.position = CGPointMake(-20, 30);
            [self addChild:_spikyBall];
        }
    }
}

-(void)throw
{
    if (self.children.count > 0)
    {
        self.texture = [SKTexture textureWithImageNamed:@"MoleyResting"];
        ADGSpikyBalls *spikyBall = [[ADGSpikyBalls alloc] init];
        spikyBall.position = [self convertPoint:_spikyBall.position toNode:self.parent];
        [self.parent addChild:spikyBall];
        [self removeAllChildren];
    }
}

@end
