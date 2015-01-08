//
//  ViewController.h
//  FootballGameApp
//

//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface ViewController : UIViewController
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
