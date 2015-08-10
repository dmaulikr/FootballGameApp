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
#import "GCHelper.h"
@import iAd;

@interface MenuViewController ()<ADInterstitialAdDelegate>
{
    ADInterstitialAd *interstitial;
    UIView *_adPlaceholderView;
}
@property (strong) NSMutableArray *savedPreferences;
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic) int64_t score;

-(void)authenticatePlayer;
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
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"Footvaders.Leaderboard";
    interstitial = [[ADInterstitialAd alloc] init];
    interstitial.delegate = self;
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
    //[self.btnStartGame setTitle:NSLocalizedString(@"StartGame", nil) forState:UIControlStateNormal];
   // [self.btnOptions setTitle:NSLocalizedString(@"OptionsLabel", nil) forState:UIControlStateNormal];
    
    //[[GCHelper sharedInstance] authenticateLocalUserInController:self];
    [self authenticatePlayer];
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
    
    if (sender.tag == 102) {
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

//Game Center
-(void)authenticatePlayer
{
    [[NSUserDefaults standardUserDefaults] setBool:self.gameCenterEnabled  forKey:@"GCEnabled"];
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:^{
                
            }];
        }else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        [[NSUserDefaults standardUserDefaults] setBool:self.gameCenterEnabled  forKey:@"GCEnabled"];
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}

- (void)showInterstitialAd {
    
    
    if (interstitial.loaded){
        _adPlaceholderView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_adPlaceholderView];
        [interstitial presentInView:_adPlaceholderView];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchDown];
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 30, 30);
        [_adPlaceholderView addSubview:button];
    }
}

-(void)closeAd:(UIButton *)sender {
    [sender removeFromSuperview];
    [_adPlaceholderView removeFromSuperview];
    
    
}

- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"Interstitial ad loaded");
    [self showInterstitialAd];
    
}

- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
}



- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSLog(@"Interstitial ad failed to load");
}


@end
