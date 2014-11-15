//
//  ADGFan.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 09/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGFan.h"
#import "ADGConstants.h"

@interface ADGFan ()

@property (nonatomic) NSArray *fanAnimations;
@property (nonatomic) SKEmitterNode *fanParticles;

@end

@implementation ADGFan

-(instancetype)init
{
    self = [super initWithImageNamed:@"Fan1"];
    
    if (self)
    {
        //Setup physics body as rect
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = kADGFanCategory;
        
        //Setup animations and store in an array
        SKTextureAtlas *fanAnimations = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        _fanAnimations = [NSArray arrayWithObjects:[fanAnimations textureNamed:@"Fan1"],
                          [fanAnimations textureNamed:@"Fan2"],
                          [fanAnimations textureNamed:@"Fan3"],
                          [fanAnimations textureNamed:@"Fan4"], nil];
        
        //Setup particle effects
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FanParticles" ofType:@"sks"];
        _fanParticles = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _fanParticles.position = CGPointMake(self.size.width, 0);
        [self addChild:_fanParticles];
    }
    
    return self;
}

-(void)setTimePerFrame:(CGFloat)timePerFrame
{
    if (_timePerFrame != timePerFrame)
    {
        _timePerFrame = timePerFrame;
        SKAction *animate = [SKAction repeatActionForever:[SKAction animateWithTextures:self.fanAnimations timePerFrame:timePerFrame]];
        [self runAction:animate];
    }
    
}

-(void)setFanBirthRate:(CGFloat)fanBirthRate
{
    if (_fanBirthRate != fanBirthRate)
    {
        _fanBirthRate = fanBirthRate;
        self.fanParticles.particleBirthRate = fanBirthRate;
    }
}



@end
