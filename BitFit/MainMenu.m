//
//  MainMenu.m
//  BitFit
//
//  Created by Chenkai Liu on 10/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "MainGame.h"

@implementation MainMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Add background image
        CCSprite *backgroundSprite  = [CCSprite spriteWithFile:@"BitFit-MenuBackground.png"];
        backgroundSprite.position = ccp(size.width/2,size.height/2);
        [self addChild:backgroundSprite z:0];
        
        // Add game title
        CCSprite *gameTitle = [CCSprite spriteWithFile:@"BitFit-MenuTitleLabel.png"];
        gameTitle.position = ccp(size.width/2, size.height-40);
        [self addChild:gameTitle];
        
        // Add floating effect to game title
        float floatduration = 1.5;
        id moveUp = [CCMoveTo actionWithDuration:floatduration position:ccp(gameTitle.position.x, gameTitle.position.y-7)];
        id moveDown = [CCMoveTo actionWithDuration:floatduration position:ccp(gameTitle.position.x, gameTitle.position.y+7)];
		[gameTitle runAction:[CCRepeat actionWithAction:[CCSequence actions:moveUp, moveDown, nil] times:INFINITY]];
        
        // Main button in menu
        CCMenuItemImage *buttonStartGame = [CCMenuItemImage itemWithNormalImage:@"BitFit-Menu-ButtonStartGame.png" selectedImage:@"BitFit-Menu-ButtonStartGame.png" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainGame scene] withColor:ccWHITE]];
        }];
        
		CCMenuItemImage *buttonLevelSelect = [CCMenuItemImage itemWithNormalImage:@"BitFit-MenuLevelSelect.png" selectedImage:@"BitFit-MenuLevelSelect.png" block:^(id sender) {
            NSLog(@"Level Select Pressed");
        }];
        
		CCMenu *mainButtonMenu = [CCMenu menuWithItems:buttonStartGame, buttonLevelSelect, nil];
		[mainButtonMenu alignItemsVerticallyWithPadding:20];
		[mainButtonMenu setPosition:ccp( size.width/2, size.height/2 - 50)];
        
        // Add the menu to the layer
		[self addChild:mainButtonMenu];
        
        // Bottom Menu
        CCMenuItemImage *buttonMusic = [CCMenuItemImage itemWithNormalImage:@"BitFit-Menu-ButtonMusic.png" selectedImage:@"BitFit-Menu-ButtonMusic.png" block:^(id sender) {
            if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume==0) {
                [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1;
                [(CCMenuItemImage*) sender setOpacity:255.0];
            }
            else {
                [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0;
                [(CCMenuItemImage*) sender setOpacity:125];
            }
        }];
        [buttonMusic setOpacity:255.0];

        
		CCMenuItemImage *buttonEffect = [CCMenuItemImage itemWithNormalImage:@"BitFit-Menu-ButtonSpeaker.png" selectedImage:@"BitFit-Menu-ButtonSpeaker.png" block:^(id sender) {
            if ([SimpleAudioEngine sharedEngine].effectsVolume==0) {
                [SimpleAudioEngine sharedEngine].effectsVolume = 1;
                [(CCMenuItemImage*) sender setOpacity:255.0];
            }
            else {
                [SimpleAudioEngine sharedEngine].effectsVolume = 0;
                [(CCMenuItemImage*) sender setOpacity:125];
            }
        }];
        
		CCMenu *bottomButtons = [CCMenu menuWithItems:buttonMusic, buttonEffect, nil];
		[bottomButtons alignItemsHorizontallyWithPadding:10];
		[bottomButtons setPosition:ccp( size.width - 60, 25)];
        
        // Add the buttom buttons to the layer
		[self addChild:bottomButtons];
        
        
	}
	return self;
}

@end
