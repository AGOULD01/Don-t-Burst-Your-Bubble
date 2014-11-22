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

@property (nonatomic) NSMutableArray *spikyBallArray;
@property (nonatomic) SKAction *moveMoley;
@property (nonatomic) SKAction *throwBall;

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
        
        //Initiallise array to hold spiky balls and for now add 3 balls for testing
        self.spikyBallArray = [NSMutableArray array];
        for (int i = 0; i <= 10; i++)
        {
            ADGSpikyBalls *spikyBall = [[ADGSpikyBalls alloc] init];
            [self.spikyBallArray addObject:spikyBall];
        }
        
        //Set repeatActionForever on Moley with range so throws ball randomly
        _throwBall = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:0.5 withRange:1], [SKAction performSelector:@selector(throw) onTarget:self]]]];
         [self reset];
    }
    
    return self;
}

-(void)prepareBall:(ADGBubble *)bubble
{
    if (self.children.count == 0)
    {
        SKSpriteNode *spikyBall = [SKSpriteNode spriteNodeWithImageNamed:@"SpikyBall"];
        spikyBall.name = @"SpikyBall";
        
        if (arc4random_uniform(4) == 0)
        {
            self.texture = [SKTexture textureWithImageNamed:@"MoleyHigh"];
            SKSpriteNode *spikyBallTwo = [SKSpriteNode spriteNodeWithImageNamed:@"SpikyBall"];
            spikyBallTwo.name = @"SpikyBall";
            spikyBall.position = CGPointMake(20, 30);
            spikyBallTwo.position = CGPointMake(-20, 30);
            [self addChild:spikyBall];
            [self addChild:spikyBallTwo];
        }
        else
        {
            if (bubble.position.x > self.position.x)
            {
                self.texture = [SKTexture textureWithImageNamed:@"MoleyRight"];
                spikyBall.position = CGPointMake(20, 30);
                [self addChild:spikyBall];
            }
            else
            {
                self.texture = [SKTexture textureWithImageNamed:@"MoleyLeft"];
                spikyBall.position = CGPointMake(-20, 30);
                [self addChild:spikyBall];
            }
        }
    }
}

-(void)throw
{
    //Enumerate thrown balls and if they have fallen off the screen add them back to the array
    [self.parent enumerateChildNodesWithName:@"SpikyBallReleased" usingBlock:^(SKNode *node, BOOL *stop)
    {
        if ([self convertPoint:node.position toNode:self.parent].y < 0)
        {
            [node removeFromParent];
            [self.spikyBallArray addObject:(ADGSpikyBalls *)node];
        }
    }];
    
    //Release held balls using enumeration block
    if (self.children.count > 0)
    {
        self.texture = [SKTexture textureWithImageNamed:@"MoleyResting"];
        [self enumerateChildNodesWithName:@"SpikyBall" usingBlock:^(SKNode *node, BOOL *stop)
        {
            if (self.spikyBallArray.count > 0)
            {
                ADGSpikyBalls *spikyBall = (ADGSpikyBalls *)self.spikyBallArray[0];
                [self.spikyBallArray removeObjectAtIndex:0];
                spikyBall.position = [self convertPoint:node.position toNode:self.parent];
                [self.parent addChild:spikyBall];
                [node removeFromParent];
            }
            else
            {
                //This code should never be called but is a back up to prevent crash if spiky ball array runs out of objects.
                ADGSpikyBalls *spikyBallBackUp = [[ADGSpikyBalls alloc] init];
                spikyBallBackUp.position = [self convertPoint:node.position toNode:self.parent];
                [self.parent addChild:spikyBallBackUp];
                [node removeFromParent];
            }
        }];
    }
}

-(void)moveMoley:(ADGBubble *)bubble
{
    _moveMoley = [SKAction moveToX:bubble.position.x duration:0.5];
    [self runAction:_moveMoley];
}

-(void)moleyWins:(SKAction *)winAnimation
{
    [self removeAllActions];
    [self removeAllChildren];
    [self runAction:winAnimation];
}

-(void)reset
{
    [self removeAllActions];
    self.texture = [SKTexture textureWithImageNamed:@"MoleyResting"];
    [self runAction:self.throwBall];
}


@end
