//
//  MenuViewController.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 15/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "MenuViewController.h"
#import "GameOptionsViewController.h"
#import "ViewController.h"
#import "UserPreferences.h"
@interface MenuViewController ()
@property (strong) NSMutableArray *savedPreferences;
@end

@implementation MenuViewController

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
    
    }
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserPreferences"];
    self.savedPreferences = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if ([self.savedPreferences count]) {
        sUserPreferences = [self.savedPreferences objectAtIndex:0];
        self.currentDifficulty = [sUserPreferences.difficulty intValue];
        self.soundIsOn = [sUserPreferences.sound boolValue];
        self.currentPlayerColor = sUserPreferences.playerColor;
        self.currentOpponentColor = sUserPreferences.opponentColor;
    }else{
        if (!self.currentDifficulty) {
            self.currentDifficulty = GameDifficultyEasy;
        }
        if (!sUserPreferences.sound) {
            self.soundIsOn = YES;
        }
        if (!self.currentOpponentColor) {
            self.currentPlayerColor = @"green";
        }
        if (!self.currentPlayerColor) {
            self.currentPlayerColor = @"yellow";
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    NSString *currentSegue = sender.titleLabel.text;
    if ([currentSegue isEqualToString:@"Options"]) {
        GameOptionsViewController *gameOptionsVC = (GameOptionsViewController *)[segue destinationViewController];
        [gameOptionsVC setSoundIsOn:self.soundIsOn];
        
        [gameOptionsVC setCurrentDifficulty:self.currentDifficulty];
        [gameOptionsVC setSelectedPlayerColor:self.currentPlayerColor];
        [gameOptionsVC setSelectedOpponentColor:self.currentOpponentColor];
        
    }else{
        ViewController *gameController = (ViewController *)[segue destinationViewController];
        [[NSUserDefaults standardUserDefaults]setInteger:self.currentDifficulty forKey:@"defenders#"];
        [gameController setDifficulty:self.currentDifficulty];
        [gameController setSoundIsEnabled:self.soundIsOn];
        [gameController setPlayerColor:self.currentPlayerColor];
        [gameController setOpponentColor:self.currentOpponentColor];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)startGame:(id)sender {
    [self performSegueWithIdentifier:@"startSegue" sender:sender];
}

- (IBAction)goToOptions:(id)sender {
    [self performSegueWithIdentifier:@"optionsSegue" sender:sender];
}
@end
