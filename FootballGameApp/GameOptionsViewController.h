//
//  GameOptionsViewController.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 15/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class UserPreferences;
typedef void (^PreferencesSavedSuccess)(BOOL success);
typedef void (^PreferencesSavedError)();
@interface GameOptionsViewController : UIViewController
{
    UserPreferences *sUserPreferences;
    AppDelegate *appDelegate;
}

//Difficulty
@property (weak, nonatomic) IBOutlet UIButton * btnEasy;
@property (weak, nonatomic) IBOutlet UIButton * btnMedium;
@property (weak, nonatomic) IBOutlet UIButton * btnHard;
@property (nonatomic)  int currentDifficulty;
//Sound Options
@property (weak, nonatomic) IBOutlet UIButton * btnSoundOn;
@property (weak, nonatomic) IBOutlet UIButton * btnSoundOff;
@property (nonatomic) BOOL soundIsOn;
//Player Colors
@property (strong, nonatomic) NSString * selectedPlayerColor;
@property (strong, nonatomic) NSString * selectedOpponentColor;



//Players Color actions
- (IBAction)blueButtonSelected:(id)sender;
- (IBAction)redButtonSelected:(id)sender;
- (IBAction)greenButtonSelected:(id)sender;
- (IBAction)yellowButtonSelected:(id)sender;





//Save or cancel
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

//Core data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray * fetchedPreferences;
@end
