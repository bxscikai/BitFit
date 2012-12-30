//
//  MainGame.m
//  BitFit
//
//  Created by Chenkai Liu on 10/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"


@implementation MainGame
@synthesize tileMap;
@synthesize background;
@synthesize player;
@synthesize objectlayer;
@synthesize objects;

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
    
        [self loadMaps];
        [self loadPlayer];        
        [self setStartPoint];
        
        self.isTouchEnabled = YES;
    }
    
    return self;
}

-(void) setStartPoint {
    NSMutableDictionary *spawnpoint  = [objects objectNamed:@"StartPoint"];
    int x = [[spawnpoint valueForKey:@"x"]integerValue];
    int y = [[spawnpoint valueForKey:@"y"]integerValue];
    [self setViewpointCenter:ccp(x,y)];
}


-(void) loadMaps {
    
    self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"mainGameMap.tmx"];
    self.background = [self.tileMap layerNamed:@"Background"];
    self.objects = [tileMap objectGroupNamed:@"Objects"];
    [self addChild:tileMap z:-1];

}

-(void) loadPlayer {
    self.player = [CCSprite spriteWithFile:@"Player.png"];
    [self addChild:self.player];
    
    
}

-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMap.mapSize.width * tileMap.tileSize.width) - winSize.width / 2);
    y = MIN(y, (tileMap.mapSize.height * tileMap.tileSize.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
    self.player.position = actualPosition;
    
}

-(CGPoint) tileCoordForPosition:(CGPoint)position {
    int x = position.x / tileMap.tileSize.width;
    int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
    return ccp(x,y);
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGame *layer = [MainGame node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)setPlayerPosition:(CGPoint)position {
    
    // Prevent player from colliding to the side
    CGPoint tileCoord = [self tileCoordForPosition:position];
    int tileGid = [background tileGIDAt:tileCoord];
    
    if (tileGid) {
        NSDictionary *properties = [tileMap propertiesForGID:tileGid];
        
        // Return if the tile is collidable
        if (properties) {
            NSString *collision = [properties valueForKey:@"Collidable"];
            
            if (collision && [collision isEqualToString:@"True"]) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"hit.caf"];
                return;
            }
            
        }
        
    }
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"move.caf"];
	player.position = position;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    NSLog(@"Current Location: %@", NSStringFromCGPoint(touchLocation));
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    
    CGPoint targetCenter = player.position;
        
    CGPoint diff = ccpSub(touchLocation, targetCenter);
            
        if (abs(diff.x) > abs(diff.y)) {
            if (diff.x > 0) {
                targetCenter.x += tileMap.tileSize.width;
            } else {
                targetCenter.x -= tileMap.tileSize.width;
            }
        } else {
            if (diff.y > 0) {
                targetCenter.y += tileMap.tileSize.height;
            } else {
                targetCenter.y -= tileMap.tileSize.height;
            }
        }
        //player.position = playerPos; // Todo: Trymove
        if (targetCenter.x <= (tileMap.mapSize.width * tileMap.tileSize.width) &&
            targetCenter.y <= (tileMap.mapSize.height * tileMap.tileSize.height) &&
            targetCenter.y >= 0 &&
            targetCenter.x >= 0 )
        {
            [self setPlayerPosition:targetCenter];
        }
    
    [self setViewpointCenter:player.position];
        
}

-(void) registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}


@end
