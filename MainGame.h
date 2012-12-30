//
//  MainGame.h
//  BitFit
//
//  Created by Chenkai Liu on 10/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainGame : CCLayer {
    
    CCTMXTiledMap *tileMap;
    CCTMXLayer *background;
    CCTMXObjectGroup *objects;
    CCSprite *player;
    
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCTMXLayer *objectlayer;
@property (nonatomic, retain) CCTMXObjectGroup *objects;
@property (nonatomic, retain) CCSprite *player;

+(CCScene *) scene;


@end
