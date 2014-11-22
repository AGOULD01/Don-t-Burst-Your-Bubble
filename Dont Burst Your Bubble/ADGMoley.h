//
//  ADGMoley.h
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 18/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ADGBubble.h"

@interface ADGMoley : SKSpriteNode

-(void)prepareBall:(ADGBubble *)bubble;
-(void)moveMoley:(ADGBubble *)bubble;
-(void)moleyWins:(SKAction *)winAnimation;
-(void)reset;



@end
