//
//  ViewController.h
//  FootballGameApp
//

//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface ViewController : UIViewController <GKGameCenterControllerDelegate>
{
    SKView * skView;
}
@property (nonatomic) BOOL soundIsEnabled;
@property (nonatomic) int difficulty;
@property (nonatomic, strong) NSString *playerColor;
@property (nonatomic, strong) NSString *opponentColor;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic)int levelNumber;
@end
