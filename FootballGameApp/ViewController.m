//
//  ViewController.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 09/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "MyScene.h"
#import "FGUtilities.h"
#import "CustomActionSheet.h"
@import AVFoundation;
@import iAd;


@interface ViewController()<ADInterstitialAdDelegate>

@property (nonatomic)AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic, strong) CustomActionSheet *customActionSheet;
@property (nonatomic) BOOL isGameCenterEnabled;

@end



@implementation ViewController

-(void)initialSetup
{
    [[FGUtilities sharedInstance] setVcObject:self];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initialSetup];
       self.levelNumber = 1;
    self.isGameCenterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"GCEnabled"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.levelNumber  forKey:@"level"];
    [[NSUserDefaults standardUserDefaults] setObject:self.playerColor   forKey:@"playerColor"];
    [[NSUserDefaults standardUserDefaults] setObject:self.opponentColor forKey:@"opponentColor"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.difficulty   forKey:@"difficulty"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeScene) name:@"closeScene" object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGCOptions:) name:@"showLB" object:Nil];
     _leaderboardIdentifier = @"Footvaders.Leaderboard";
    
    
//    _pauseButton = [[UIButton alloc]init];
//    _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_pauseButton addTarget:self
//                action:@selector(pauseGame)
//      forControlEvents:UIControlEventTouchDown];
//    [_pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
//    _pauseButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    _pauseButton.frame = CGRectMake(self.view.frame.size.width/2 + 55, 7.5, 160.0, 40.0);
//    [self.view addSubview:_pauseButton];
    
    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [scene setPlayerColor:self.playerColor];
    [scene setOpponentColor:self.opponentColor];
    
    // Present the scene.
    [skView presentScene:scene];
}
-(void)closeScene
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeScene" object:nil];
}

- (IBAction)showGCOptions:(id)sender {
    // Allow the action sheet to be displayed if only the gameCenterEnabled flag is true, meaning if only
    // a player has been authenticated.
    if (self.isGameCenterEnabled) {
        if (_customActionSheet != nil) {
            _customActionSheet = nil;
        }
        
        // Create a CustomActionSheet object and handle the tapped button in the completion handler block.
        _customActionSheet = [[CustomActionSheet alloc] initWithTitle:@""
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"View Leaderboard", @"View Achievements", @"Reset Achievements", nil];
        [_customActionSheet showInView:self.view
                 withCompletionHandler:^(NSString *buttonTitle, NSInteger buttonIndex) {
                     
                     if ([buttonTitle isEqualToString:@"View Leaderboard"]) {
                         [self showLeaderboardAndAchievements:YES];
                     }
                     else if ([buttonTitle isEqualToString:@"View Achievements"]) {
                         [self showLeaderboardAndAchievements:NO];
                     }
                     else{
                         
                     }
                 }];
    }
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = self.leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle]URLForResource:@"crowd" withExtension:@"mp3"];
    
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:backgroundMusicURL error:&error];
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer setVolume:0.3];
    [self.backgroundMusicPlayer prepareToPlay];
    if (self.soundIsEnabled) {
       [self.backgroundMusicPlayer play];
    }
    // Configure the view.
    skView = (SKView *)self.view;
    if (skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        // Create and configure the scene.
        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        MyScene *myScene = [MyScene sceneWithSize:skView.bounds.size];
        [myScene setDifficulty:self.difficulty];
        [myScene setPlayerColor:self.playerColor];
        [myScene setOpponentColor:self.opponentColor];
        // Present the scene.
        [skView presentScene:myScene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)pauseGame
{
    skView.paused = YES;
    UIView *pauseView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 200, 50, self.view.frame.size.width, 150)];
    pauseView.tag = 1001;
    [pauseView setBackgroundColor:[UIColor whiteColor]];
    UIButton *unpauseButton = [[UIButton alloc]init];
    unpauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unpauseButton addTarget:self action:@selector(unpauseGame) forControlEvents:UIControlEventTouchUpInside];
    [unpauseButton setFrame:CGRectMake(pauseView.frame.size.width / 3, 50, 100, 20)];
    [unpauseButton setTitle:@"Resume" forState:UIControlStateNormal];
    [unpauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)unpauseGame
{
    skView.paused = NO;
    UIView *pauseView = [skView viewWithTag:1001];
    [pauseView removeFromSuperview];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
