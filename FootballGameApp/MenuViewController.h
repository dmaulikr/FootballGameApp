//
//  MenuViewController.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 15/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//
typedef NS_ENUM(NSInteger, difficulties) {
    GameDifficultyEasy = 1,
    GameDifficultyMedium,
    GameDifficultyHard
};
#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <GameKit/GameKit.h>
@class UserPreferences;
@interface MenuViewController : UIViewController
{
    UserPreferences *sUserPreferences;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *btnStartGame;
@property (weak, nonatomic) IBOutlet UIButton *btnOptions;
@property (nonatomic) int currentDifficulty;
@property (nonatomic) BOOL soundIsOn;
@property (nonatomic, strong) NSString *currentPlayerColor;
@property (nonatomic, strong) NSString *currentOpponentColor;

//Core data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray * fetchedPreferences;

- (IBAction)startGame:(id)sender;
- (IBAction)goToOptions:(id)sender;

@end
