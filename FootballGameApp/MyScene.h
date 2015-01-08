//
//  MyScene.h
//  FootballGameApp
//

//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef void (^PlayerColorBlock)();
typedef void (^OpponentColorBlock)();
@interface MyScene : SKScene <SKPhysicsContactDelegate>
@property(nonatomic) BOOL *isGamePaused;
@property (nonatomic) int difficulty;
@property (nonatomic, strong) NSString *playerColor;
@property (nonatomic, strong) NSString *opponentColor;
@end
