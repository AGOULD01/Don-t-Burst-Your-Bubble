//
//  ADGScrollingBackground.m
//  Dont Burst Your Bubble
//
//  Created by Adam Gould on 23/11/2014.
//  Copyright (c) 2014 Adam Gould. All rights reserved.
//

#import "ADGScrollingBackground.h"

@interface ADGScrollingBackground ()

@property (nonatomic) SKSpriteNode *bottomMostTile;

@end

@implementation ADGScrollingBackground

-(id)initWithTiles:(NSArray *)tileSpriteNodes
{
    if (self == [super init])
    {
        for (SKSpriteNode *tile in tileSpriteNodes)
        {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
    }
    return self;
}

- (void)layoutTiles:(CGFloat)sceneWidth
{
    self.bottomMostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop)
     {
         SKSpriteNode *tile = (SKSpriteNode *)node;
         tile.position = CGPointMake(tile.position.x + ((sceneWidth - tile.size.width) * 0.5), self.bottomMostTile.position.y + self.bottomMostTile.size.height);
         self.bottomMostTile = tile;
     }];
}

- (void)updateWithTimeElapsed:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElapsed:timeElapsed];
    
    if (self.verticalScrollSpeed < 0 && self.scene)
    {
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop)
         {
             CGPoint nodePositionInScene = [self convertPoint:node.position toNode:self.scene];
             
             if (nodePositionInScene.y + node.frame.size.height <
                 -self.scene.size.height * self.scene.anchorPoint.y)
             {
                 node.position = CGPointMake(node.position.x, self.bottomMostTile.position.y + self.bottomMostTile.size.height);
                 self.bottomMostTile = (SKSpriteNode *)node;
             }
         }];
    }
}





@end
