//
//  GameOptionsViewController.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 15/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "GameOptionsViewController.h"
#import "MenuViewController.h"
#import "UserPreferences.h"

@interface GameOptionsViewController ()
@property(strong) NSMutableArray * savedPreferencesArray;
@end

@implementation GameOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate= [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedPreferences = [appDelegate getUserPreferences];
    
    switch (self.currentDifficulty) {
        case GameDifficultyEasy:
            [self.btnEasy setSelected:YES];
            [self.btnMedium setSelected:NO];
            [self.btnHard setSelected:NO];
            break;
        case GameDifficultyMedium:
            [self.btnEasy setSelected:NO];
            [self.btnMedium setSelected:YES];
            [self.btnHard setSelected:NO];
            break;
        case GameDifficultyHard:
            [self.btnEasy setSelected:NO];
            [self.btnMedium setSelected:NO];
            [self.btnHard setSelected:YES];
            break;
        default:
            break;
    }
    switch ((int)self.soundIsOn) {
        case 1:
            [self.btnSoundOn setSelected:YES];
            [self.btnSoundOff setSelected:NO];
            break;
        case 0:
            [self.btnSoundOn setSelected:NO];
            [self.btnSoundOff setSelected:YES];
            break;
        default:
            break;
    }
    
    
    
    [self.btnEasy addTarget:self action:@selector(setDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMedium addTarget:self action:@selector(setDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnHard addTarget:self action:@selector(setDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnSoundOn addTarget:self action:@selector(setSoundPreference:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSoundOff addTarget:self action:@selector(setSoundPreference:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnCancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
   /* for (UIButton *roundedButton in self.view.subviews)
    {
        if (roundedButton.tag > 2999) {
            [roundedButton.layer setCornerRadius:roundedButton.frame.size.height / 2];
            [roundedButton.layer setBorderWidth:1];
            [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
        }
    }
    */

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserPreferences"];
    self.savedPreferencesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag > 2999 && roundedButton.tag < 3999) {
                if ([self.selectedPlayerColor isEqualToString:@"red"]&& (roundedButton.tag == 3002)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedPlayerColor isEqualToString:@"blue"]&& (roundedButton.tag == 3001)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedPlayerColor isEqualToString:@"green"]&& (roundedButton.tag == 3003)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedPlayerColor isEqualToString:@"yellow"]&& (roundedButton.tag == 3004)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }
            }else if (roundedButton.tag > 3999)
            {
                if ([self.selectedOpponentColor isEqualToString:@"red"]&& (roundedButton.tag == 4002)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedOpponentColor isEqualToString:@"blue"]&& (roundedButton.tag == 4001)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedOpponentColor isEqualToString:@"green"]&& (roundedButton.tag == 4003)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }else if ([self.selectedOpponentColor isEqualToString:@"yellow"]&& (roundedButton.tag == 4004)) {
                    [roundedButton.layer setBorderWidth:3];
                    [roundedButton.layer setBorderColor:[UIColor blackColor].CGColor];
                    continue;
                }
            }
        }
    
}
#pragma mark Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)blueButtonSelected:(id)sender {
    UIButton * blueButton = sender;
    
    if (blueButton.tag == 3001) {
        [blueButton setSelected:YES];
        [blueButton.layer setBorderWidth:3];
        [blueButton.layer setBorderColor:[UIColor blackColor].CGColor];
        self.selectedPlayerColor = @"blue";
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 3002 || roundedButton.tag == 3003 || roundedButton.tag == 3004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }

    }else{
        [blueButton setSelected:YES];
        self.selectedOpponentColor = @"blue";
        [blueButton.layer setBorderWidth:3];
        [blueButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 4002 || roundedButton.tag == 4003 || roundedButton.tag == 4004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
    }
}

- (IBAction)redButtonSelected:(id)sender {
    UIButton * redButton = sender;
    
    if (redButton.tag == 3002) {
        [redButton setSelected:YES];
        self.selectedPlayerColor = @"red";
        [redButton.layer setBorderWidth:3];
        [redButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 3001 || roundedButton.tag == 3003 || roundedButton.tag == 3004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
        
    }else{
        [redButton setSelected:YES];
        [redButton.layer setBorderWidth:3];
        [redButton.layer setBorderColor:[UIColor blackColor].CGColor];
        self.selectedOpponentColor = @"red";
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 4001 || roundedButton.tag == 4003 || roundedButton.tag == 4004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
    }
}

- (IBAction)greenButtonSelected:(id)sender {
    UIButton * greenButton = sender;
    
    if (greenButton.tag == 3003) {
        [greenButton setSelected:YES];
        self.selectedPlayerColor = @"green";
        [greenButton.layer setBorderWidth:3];
        [greenButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 3001 || roundedButton.tag == 3002 || roundedButton.tag == 3004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
        
    }else{
        [greenButton setSelected:YES];
        self.selectedOpponentColor = @"green";
        [greenButton.layer setBorderWidth:3];
        [greenButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 4001 || roundedButton.tag == 4002 || roundedButton.tag == 4004) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
    }
}

- (IBAction)yellowButtonSelected:(id)sender {
    UIButton *yellowButton = sender;
    if (yellowButton.tag == 3004) {
        [yellowButton setSelected:YES];
        self.selectedPlayerColor = @"yellow";
        [yellowButton.layer setBorderWidth:3];
        [yellowButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 3001 || roundedButton.tag == 3002 || roundedButton.tag == 3003) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
        }
        
    }else{
        [yellowButton setSelected:YES];
        self.selectedOpponentColor = @"yellow";
        [yellowButton.layer setBorderWidth:3];
        [yellowButton.layer setBorderColor:[UIColor blackColor].CGColor];
        for (UIButton *roundedButton in self.view.subviews)
        {
            if (roundedButton.tag == 4001 || roundedButton.tag == 4002 || roundedButton.tag == 4003) {
                [roundedButton setSelected:NO];
                if (!roundedButton.selected) {
                    [roundedButton.layer setBorderColor:[UIColor clearColor].CGColor];
                }
            }
            
}
    }
}


-(void)setDifficulty:(UIButton *)sender
{
    switch (sender.tag) {
        case 1001:
            [self.btnEasy setSelected:YES];
            [self.btnMedium setSelected:NO];
            [self.btnHard setSelected:NO];
            self.currentDifficulty = 1;
            break;
        case 1002:
            [self.btnEasy setSelected:NO];
            [self.btnMedium setSelected:YES];
            [self.btnHard setSelected:NO];
            self.currentDifficulty = 2;
            break;
        case 1003:
            [self.btnEasy setSelected:NO];
            [self.btnMedium setSelected:NO];
            [self.btnHard setSelected:YES];
            self.currentDifficulty = 3;
            break;
        default:
            break;
    }
}

-(void)setSoundPreference:(UIButton *)sender
{
    switch (sender.tag) {
        case 2001:
            [self.btnSoundOn setSelected:YES];
            [self.btnSoundOff setSelected:NO];
            self.soundIsOn = YES;
            break;
        case 2002:
            [self.btnSoundOn setSelected:NO];
            [self.btnSoundOff setSelected:YES];
            self.soundIsOn = NO;
            break;
        default:
            break;
    }
}

-(void)savePreferencesWithSuccess: (PreferencesSavedSuccess)success onError: (PreferencesSavedError)savingError
{
    if ([self.savedPreferencesArray count]) {
        NSManagedObjectContext *newPreferenceInfo;
        newPreferenceInfo = [self.savedPreferencesArray objectAtIndex:0];
        sUserPreferences = [self.savedPreferencesArray objectAtIndex:0];
        if ((![sUserPreferences.difficulty isEqualToString:[NSString stringWithFormat:@"%d",self.currentDifficulty]]) ||
            (![sUserPreferences.sound isEqualToString:[NSString stringWithFormat:@"%d", (int)self.soundIsOn]]) ||
            (![sUserPreferences.playerColor isEqualToString:self.selectedPlayerColor])
            || (![sUserPreferences.opponentColor isEqualToString:self.selectedOpponentColor])) {
            [newPreferenceInfo setValue:[NSString stringWithFormat:@"%d", self.currentDifficulty]
                                 forKey:@"difficulty"];
            [newPreferenceInfo setValue:[NSString stringWithFormat:@"%d", (int)self.soundIsOn] forKey:@"sound"];
            [newPreferenceInfo setValue:self.selectedPlayerColor forKey:@"playerColor"];
            [newPreferenceInfo setValue:self.selectedOpponentColor forKey:@"opponentColor"];
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                savingError(error);
            }
           
            success(YES);
        }else{
            success(YES);
        }
    }else{
        NSManagedObjectContext *context = [self managedObjectContext];
        UserPreferences *newPreferenceInfo = [NSEntityDescription insertNewObjectForEntityForName:@"UserPreferences" inManagedObjectContext:context];
        newPreferenceInfo.difficulty = [NSString stringWithFormat:@"%d",self.currentDifficulty];
        newPreferenceInfo.sound = [NSString stringWithFormat:@"%d", (int)self.soundIsOn];
        newPreferenceInfo.playerColor = self.selectedPlayerColor;
        newPreferenceInfo.opponentColor = self.selectedOpponentColor;
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            savingError();
            //self.activityIndicator.hidden = YES;
            //[self.activityIndicator stopAnimating];
        }
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserPreferences"];
        self.savedPreferencesArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
        
        success(YES);
    }
}


-(void)saveAction
{
    [self savePreferencesWithSuccess:^(BOOL success) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } onError:^{
        UIAlertView *confirmAlertView=[[UIAlertView alloc]initWithTitle:@"Error! :(" message:@"Couldn't save correctly the preferences" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [confirmAlertView show];
    }];
}


-(void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
