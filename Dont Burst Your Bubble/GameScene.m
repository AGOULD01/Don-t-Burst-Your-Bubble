//
//  GameScene.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 09/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "GameScene.h"
#import "ADGFan.h"
#import "ADGBubble.h"
#import "ADGConstants.h"

@interface GameScene () 

@property (nonatomic) ADGFan *leftFan;
@property (nonatomic) ADGFan *rightFan;
@property (nonatomic) ADGBubble *bubble;
@property (nonatomic) DirectionForce directionForce;
@property (nonatomic) SKNode *mainLayer;
@property (nonatomic) SKEmitterNode *bubbleBurstEmitter;
@property (nonatomic) BOOL gameOver;

@end

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        //Set background color to sky blue
        self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];
        
        //Setup physics
        self.physicsWorld.contactDelegate = self;
        
        //Init mainlayer
        _mainLayer = [SKNode node];
        [self addChild:_mainLayer];
        
        //Load left fan
        _leftFan = [[ADGFan alloc] init];
        _leftFan.position = CGPointMake(_leftFan.size.width * 0.5, self.size.height * 0.5);
        _leftFan.timePerFrame = 0.2;
        [_mainLayer addChild:_leftFan];
        
        //Load right fan
        _rightFan = [[ADGFan alloc] init];
        _rightFan.position = CGPointMake(self.size.width - _rightFan.size.width * 0.5, self.size.height * 0.5);
        _rightFan.zRotation = M_PI;
        _rightFan.timePerFrame = 0.2;
        [_mainLayer addChild:_rightFan];
        
        //Load bubble
        _bubble = [[ADGBubble alloc] init];
        _bubble.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_mainLayer addChild:_bubble];
        
        //Set initial values
        _directionForce = ApplyNone;
        _bubble.bubbleBurst = NO;
        _gameOver = NO;
        
        //Test Spiky Ball
        SKSpriteNode *testBall = [SKSpriteNode spriteNodeWithImageNamed:@"SpikyBall"];
        testBall.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.75);
        [_mainLayer addChild:testBall];
    }
    return self;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (!_gameOver)
    {
        //Respond to the first touch
        UITouch *touch = [touches allObjects][0];
        CGPoint location = [touch locationInNode:self];
        if (location.x >= self.size.width * 0.5)
        {
            //Pressed right side of screen so push bubble left and increase speed of fan.
            self.directionForce = ApplyLeft;
            _rightFan.timePerFrame = 0.05;
            _rightFan.fanBirthRate = 40;
        }
        else
        {
            //Pressed left side of screen so push bubble right and increase speed of fan.
            self.directionForce = ApplyRight;
            _leftFan.timePerFrame = 0.05;
            _leftFan.fanBirthRate = 40;
        }
    }
    else
    {
        //Temporary until the menu is setup. This is for testing purposes.
        _bubble = [[ADGBubble alloc] init];
        _bubble.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [_mainLayer addChild:_bubble];
        _gameOver = NO;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Touch ended. No force on the bubble. Decrease fans to normal speed.
    self.directionForce = ApplyNone;
    _rightFan.timePerFrame = 0.2;
    _leftFan.timePerFrame = 0.2;
    _rightFan.fanBirthRate = 20;
    _leftFan.fanBirthRate = 20;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    //Applies force to bubble from ADGBubble and pass direction.
    [_bubble applyForce:self.directionForce];
}

#pragma mark - Contact Delegate

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    [self bubbleExplosion:@"BurstBubble" forLocation:self.bubble.position];
    _gameOver = YES;
    
    if (contact.bodyA.categoryBitMask == kADGBubbleCategory)
    {
        [self.bubble bubbleBurst:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kADGBubbleCategory)
    {
        [self.bubble bubbleBurst:contact.bodyA];
    }
}

#pragma mark - Helper Methods

-(void)bubbleExplosion:(NSString *)nameForResource forLocation:(CGPoint)position
{
    //Setup particle emitter
    NSString *pathForBurstBubble = [[NSBundle mainBundle] pathForResource:nameForResource ofType:@"sks"];
    self.bubbleBurstEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForBurstBubble];
    self.bubbleBurstEmitter.position = position;
    [_mainLayer addChild:self.bubbleBurstEmitter];
    SKAction *applyParticleEffect = [SKAction sequence:@[[SKAction waitForDuration:1], [SKAction removeFromParent]]];
    [self.bubbleBurstEmitter runAction:applyParticleEffect];
}




@end
