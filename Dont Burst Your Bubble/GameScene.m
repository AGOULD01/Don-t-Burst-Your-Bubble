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
#import "ADGMoley.h"
#import "ADGScrollingBackground.h"
#import "ADGMoleyBabies.h"

typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;

@interface GameScene () 

@property (nonatomic) ADGFan *leftFan;
@property (nonatomic) ADGFan *rightFan;
@property (nonatomic) ADGBubble *bubble;
@property (nonatomic) ADGMoley *moley;
@property (nonatomic) DirectionForce directionForce;
@property (nonatomic) SKNode *mainLayer;
@property (nonatomic) GameState gameState;
@property (nonatomic) SKAction *winAnimation;
@property (nonatomic) ADGScrollingBackground *background;
@property (nonatomic) NSMutableArray *babyMoleyPool;

@end

static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {

        //Set background color to sky blue
        self.backgroundColor = [SKColor colorWithRed:0.61569 green:0.83529 blue:0.93725 alpha:1.0];
        
        //Setup physics
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0, -1);
        
        //Init mainlayer
        _mainLayer = [SKNode node];
        [self addChild:_mainLayer];
        
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
        for (int i = 1; i < 4; i++)
        {
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Background%i",i]]]];
        }
        _background = [[ADGScrollingBackground alloc] initWithTiles:backgroundTiles];
        [_background layoutTiles:self.size.width];
        _background.verticalScrollSpeed = -40;
        [_mainLayer addChild:_background];
        
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
        _gameState = GameReady;
        
        //Set up Moley
        _moley = [[ADGMoley alloc] init];
        _moley.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.9);
        [_mainLayer addChild:_moley];
        
        SKAction *prepare = [SKAction sequence:@[[SKAction waitForDuration:2 withRange:1], [SKAction performSelector:@selector(prepare) onTarget:self]]];
        [self runAction:[SKAction repeatActionForever:prepare]];
        
        //Setup winning animation and cache in SKAction winAnimation
        SKAction *winFrames = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"MoleyResting"], [SKTexture textureWithImageNamed:@"MoleyHigh"]] timePerFrame:0.5];
        SKAction *moveToCentre = [SKAction moveToX:self.size.width * 0.5 duration:1];
        self.winAnimation = [SKAction repeatActionForever:[SKAction group:@[winFrames, moveToCentre]]];
        
        //Initiliase pool and fill babyMoleyPool with 10 BabyMoley objects
        self.babyMoleyPool = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i++)
        {
            //Setup BabyMoleys
            ADGMoleyBabies *baby = [[ADGMoleyBabies alloc] init];
            [self.babyMoleyPool addObject:baby];
        }
        
        SKAction *spawnBabies = [SKAction sequence:@[[SKAction waitForDuration:3 withRange:0.5], [SKAction performSelector:@selector(spawnBaby) onTarget:self]]];
        [self runAction:[SKAction repeatActionForever:spawnBabies]];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if (self.gameState == GameReady)
    {
        self.gameState = GameRunning;
    }
    
    if (self.gameState == GameRunning)
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
        if ((int)_moley.position.x == (int)(self.size.width * 0.5))
        {
            _bubble = [[ADGBubble alloc] init];
            _bubble.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
            [_mainLayer addChild:_bubble];
            [_moley reset];
            self.gameState = GameReady;
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Touch ended. No force on the bubble. Decrease fans to normal speed.
    if (self.gameState == GameRunning)
    {
        self.directionForce = ApplyNone;
        _rightFan.timePerFrame = 0.2;
        _leftFan.timePerFrame = 0.2;
        _rightFan.fanBirthRate = 20;
        _leftFan.fanBirthRate = 20;
    }

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS)
    {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.background updateWithTimeElapsed:timeElapsed];
    
    if (self.gameState == GameRunning)
    {
        //Applies force to bubble from ADGBubble and pass direction.
        [_bubble applyForce:self.directionForce];
        //Moves Moley from ADGMoley so that he runs marginally behind the bubble
        [_moley moveMoley:self.bubble];
    }
}

#pragma mark - Contact Delegate

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if (self.gameState == GameRunning)
    {
        if (contact.bodyA.categoryBitMask == kADGBubbleCategory)
        {
            [self.bubble bubbleBurst:contact.bodyB];
            [self gameOver];
        }
        else if (contact.bodyB.categoryBitMask == kADGBubbleCategory)
        {
            [self.bubble bubbleBurst:contact.bodyA];
            [self gameOver];
        }
        else if (contact.bodyA.categoryBitMask == kADGMoleyBabyCategory)
        {
            [self emitParticleEffectForString:@"BabyMoleysHit" forLocation:contact.bodyA.node.position];
            ADGMoleyBabies *moleyBaby = (ADGMoleyBabies *)contact.bodyA.node;
            [moleyBaby babyMoleyHit:contact.bodyB];
            [self.babyMoleyPool addObject:moleyBaby];
        }
        else if (contact.bodyB.categoryBitMask == kADGMoleyBabyCategory)
        {
            [self emitParticleEffectForString:@"BabyMoleysHit" forLocation:contact.bodyB.node.position];
            ADGMoleyBabies *moleyBaby = (ADGMoleyBabies *)contact.bodyB.node;
            [moleyBaby babyMoleyHit:contact.bodyA];
            [self.babyMoleyPool addObject:moleyBaby];
        }
    }
}

#pragma mark - Helper Methods

-(void)gameOver
{
    self.directionForce = ApplyNone;
    _rightFan.timePerFrame = 0.2;
    _leftFan.timePerFrame = 0.2;
    _rightFan.fanBirthRate = 20;
    _leftFan.fanBirthRate = 20;
    [self emitParticleEffectForString:@"BurstBubble" forLocation:self.bubble.position];
    self.gameState = GameOver;
    
    [_moley moleyWins:self.winAnimation];
    
    //Move babies below the screen and then remove then add back to pool
    [_mainLayer enumerateChildNodesWithName:@"MoleyBabies" usingBlock:^(SKNode *node, BOOL *stop)
     {
         [node removeAllActions];
         SKAction *gameOverMoleyBabies = [SKAction sequence:@[[SKAction setTexture:[SKTexture textureWithImageNamed:@"MoleyResting"]], [SKAction moveToY:-50 duration:2], [SKAction removeFromParent]]];
         [node runAction:gameOverMoleyBabies completion:^
          {
              [self.babyMoleyPool addObject:(ADGMoleyBabies *)node];
          }];
     }];
}


-(void)emitParticleEffectForString:(NSString *)nameForResource forLocation:(CGPoint)position
{
    //Setup particle emitter
    NSString *pathForBurstBubble = [[NSBundle mainBundle] pathForResource:nameForResource ofType:@"sks"];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:pathForBurstBubble];
    emitterNode.position = position;
    [_mainLayer addChild:emitterNode];
    SKAction *applyParticleEffect = [SKAction sequence:@[[SKAction waitForDuration:1], [SKAction removeFromParent]]];
    [emitterNode runAction:applyParticleEffect];
}

-(void)prepare
{
    if (self.gameState == GameRunning)
    {
        [_moley prepareBall:_bubble];
    }
}

-(void)spawnBaby
{
    if (self.gameState == GameRunning)
    {
        ADGMoleyBabies *moleyBaby = (ADGMoleyBabies *)self.babyMoleyPool[0];
        [self.babyMoleyPool removeObjectAtIndex:0];
        CGFloat randXPos = arc4random_uniform(self.size.width - 120) + 60;
        moleyBaby.position = CGPointMake(randXPos, -50);
        [_mainLayer addChild:moleyBaby];
        
        SKAction *moveOut;
        if (randXPos >= self.size.width * 0.5)
        {
            moveOut = [SKAction moveToX:self.size.width + 100 duration:2];
        }
        else
        {
            moveOut = [SKAction moveToX:-100 duration:2];
        }
        
        SKAction *moveUp = [SKAction sequence:@[[SKAction moveToY:self.bubble.position.y - 50 duration:12],
                                                [SKAction setTexture:[SKTexture textureWithImageNamed:@"MoleyHigh"]],
                                                [SKAction moveToY:self.bubble.position.y + 100 duration:3], moveOut]];
        [moleyBaby runAction:moveUp completion:^
        {
            [moleyBaby removeAllActions];
            [moleyBaby removeFromParent];
            [moleyBaby setTexture:[SKTexture textureWithImageNamed:@"MoleyResting"]];
            [self.babyMoleyPool addObject:moleyBaby];
        }];
    }
}


@end
