//
//  ADGScrollingBackground.h
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 23/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGScrollingNode.h"

@interface ADGScrollingBackground : ADGScrollingNode

-(id)initWithTiles:(NSArray *)tileSpriteNodes;

-(void)layoutTiles:(CGFloat)sceneWidth;

@end
