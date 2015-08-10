//
//  GameOverScene.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 11/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "GameOverScene.h"
#import "MyScene.h"
#import "FGUtilities.h"

@interface GameOverScene ()
@property (nonatomic) BOOL soundIsEnabled;
@property (nonatomic) NSInteger finalScore;
@property (nonatomic) NSInteger difficulty;
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@property (nonatomic) int64_t score;
@end
@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won
{
     _leaderboardIdentifier = @"Footvaders.Leaderboard";
    if (self = [self initWithSize:size]) {
        self.soundIsEnabled = [[FGUtilities sharedInstance]vcObject].soundIsEnabled;
        self.difficulty = (NSInteger)[[FGUtilities sharedInstance]vcObject].difficulty;
        //1
        self.backgroundColor = [SKColor colorWithRed:158.0f/255.0f green:229.0f/255.0f blue:88.0f/255.0f alpha:1];
        //2
        NSString *message;
        NSString *accuracyMessage;
        NSString *difficultyBonus;
        NSString *finalScoreMessage;
        if (won) {
            NSInteger defaultLevel= [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
            defaultLevel++;
            [[NSUserDefaults standardUserDefaults]setInteger:defaultLevel forKey:@"level"];
            NSInteger currentLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"defenders#"];
            currentLevel++;
            [[NSUserDefaults standardUserDefaults]setInteger:currentLevel forKey:@"defenders#"];
            message = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"Level", nil), (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"level"]];
            if (self.soundIsEnabled) {
             [self runAction:[SKAction playSoundFileNamed:@"cheerCrowd.mp3" waitForCompletion:NO]];
            }
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            label.text = message;
            label.fontSize = 40;
            label.fontColor = [SKColor blackColor];
            label.position = CGPointMake(self.size.width / 2, self.size.height/2);
            [self addChild:label];
            
            //4
            [self runAction:
             [SKAction sequence:@[
                                  [SKAction waitForDuration:3.0],[SKAction runBlock:^{
                 //5
                 SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                 SKScene *myScene = [[MyScene alloc]initWithSize:self.size];
                 [self.view presentScene:myScene transition:reveal];
             }]
                                  ]]
             ];
        }else{
            
             //[[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"ballsUsed"];

            NSInteger currentScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentScore"];
            NSInteger accuracy = 100 *  [[NSUserDefaults standardUserDefaults] floatForKey:@"accuracyPercentage"];
           self.finalScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"accuracyBonus"];
            
            
            message =[NSString stringWithFormat:@"%@ %ld %@",NSLocalizedString(@"DefeatedLbl", nil), (long)currentScore, NSLocalizedString(@"DefendersLbl", nil)];
            accuracyMessage = [NSString stringWithFormat:@"%@ %ld %%",NSLocalizedString(@"AccuracyLbl", nil), (long)accuracy];
            difficultyBonus = [NSString stringWithFormat:@"%@ %ld x",NSLocalizedString(@"DifficultyMultiplier", nil), self.difficulty];
            self.finalScore *= self.difficulty;
            self.score = self.finalScore;
            finalScoreMessage = [NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"FinalScore", nil), (long)self.finalScore];
            [self reportMyScore];
            if (self.soundIsEnabled) {
                [self runAction:[SKAction playSoundFileNamed:@"booCrowd.mp3" waitForCompletion:NO]];
            }
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            label.text = message;
            label.fontSize = 20;
            label.fontColor = [SKColor blackColor];
            label.position = CGPointMake(self.size.width / 2, self.size.height/2 - 20);
            [self addChild:label];
            
            SKLabelNode *accuracyLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            accuracyLabel.text = accuracyMessage;
            accuracyLabel.fontSize = 20;
            accuracyLabel.fontColor = [SKColor blackColor];
            accuracyLabel.position = CGPointMake(self.size.width / 2, (label.frame.origin.y + label.frame.size.height + 10));
            [self addChild:accuracyLabel];
            
            SKLabelNode *difficultyScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            difficultyScoreLabel.text = difficultyBonus;
            difficultyScoreLabel.fontSize = 20;
            difficultyScoreLabel.fontColor = [SKColor blackColor];
            difficultyScoreLabel.position = CGPointMake(self.size.width / 2, (accuracyLabel.frame.origin.y + accuracyLabel.frame.size.height + 10));
            [self addChild:difficultyScoreLabel];
            
            SKLabelNode *finalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Bold"];
            finalScoreLabel.text = finalScoreMessage;
            finalScoreLabel.fontSize = 20;
            finalScoreLabel.fontColor = [SKColor blackColor];
            finalScoreLabel.position = CGPointMake(self.size.width / 2, (difficultyScoreLabel.frame.origin.y + difficultyScoreLabel.frame.size.height + 10));
            [self addChild:finalScoreLabel];
            
            
            
            SKLabelNode *playAgain = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            
            SKShapeNode *circleNode = [[SKShapeNode alloc]init];
            circleNode.name = @"playAgainNode";
            circleNode.path = [UIBezierPath bezierPathWithRect:CGRectMake(-70, -10, 135, 30)].CGPath;
            circleNode.fillColor = [SKColor clearColor];
            circleNode.lineWidth = 2;
            circleNode.strokeColor = [SKColor whiteColor];
            
            
            [playAgain setText:NSLocalizedString(@"PlayAgainLbl", nil)];
            playAgain.fontColor = [SKColor whiteColor];
            playAgain.fontSize = 20;
            playAgain.position = CGPointMake(self.size.width /6, self.size.height / 1.1);
            [playAgain addChild:circleNode];
            [self addChild:playAgain];
            
            
            
            
            SKLabelNode *menuLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [menuLabel setText:NSLocalizedString(@"ExitLbl", nil)];
            menuLabel.fontColor = [SKColor whiteColor];
            menuLabel.position = CGPointMake(self.size.width - 100, self.size.height / 1.1);
            menuLabel.fontSize = 20;
            [self addChild:menuLabel];
            SKShapeNode *exitCircleNode = [[SKShapeNode alloc]init];
            exitCircleNode.path = [UIBezierPath bezierPathWithRect:CGRectMake(-70, -10, 125, 30)].CGPath;
            exitCircleNode.name = @"exitNode";
            exitCircleNode.fillColor = [SKColor clearColor];
            exitCircleNode.lineWidth = 2;
            exitCircleNode.strokeColor = [SKColor whiteColor];
            
            [menuLabel addChild:exitCircleNode];
            [[NSUserDefaults standardUserDefaults]setFloat:0.0f forKey:@"accuracyPercentage"];
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"accuracyBonus"];
           
            self.gameCenterEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"GCEnabled"];
             if (self.gameCenterEnabled) {
            SKLabelNode *gcLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [gcLabel setText:@"Game Center"];
            gcLabel.fontColor = [SKColor whiteColor];
            gcLabel.position = CGPointMake(self.size.width - 100, self.size.height / 4);
            gcLabel.fontSize = 20;
            [self addChild:gcLabel];
            SKShapeNode *GCNode = [[SKShapeNode alloc]init];
            GCNode.path = [UIBezierPath bezierPathWithRect:CGRectMake(-65, -10, 130, 30)].CGPath;
            GCNode.name = @"gcNode";
            GCNode.fillColor = [SKColor clearColor];
            GCNode.lineWidth = 2;
            GCNode.strokeColor = [SKColor whiteColor];
            
           
                [gcLabel addChild:GCNode];
            }
            
            //4
          /*  [self runAction:
             [SKAction sequence:@[
                                  [SKAction waitForDuration:3.0],[SKAction runBlock:^{
                 //5
                 SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                 SKScene *myScene = [[MyScene alloc]initWithSize:self.size];
                 [self.view presentScene:myScene transition:reveal];
             }]
                                  ]]
             ];*/
        }
        //3
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
   
    if ([node isKindOfClass:[SKShapeNode class]]) {
        //SKLabelNode *label = (SKLabelNode *)node;
        if ([node.name isEqualToString:@"exitNode"]) {
            [self exit];
        }
        else if ([node.name isEqualToString:@"playAgainNode"]) {
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"level"];
            [[NSUserDefaults standardUserDefaults]setInteger:[[FGUtilities sharedInstance]vcObject].difficulty forKey:@"defenders#"];
            
            [self runAction:
             [SKAction sequence:@[
                                  [SKAction waitForDuration:0.5],[SKAction runBlock:^{
                 //5
                 SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                 SKScene *myScene = [[MyScene alloc]initWithSize:self.size];
                 [self.view presentScene:myScene transition:reveal];
             }]
                                  ]]
             ];

        }else if ([node.name isEqualToString:@"gcNode"]){
            [self showLB];
        }
    }
    
}

-(void)reportMyScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = _score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

-(void)showLB{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showLB" object:nil];
}


-(void)exit
{
    [self runAction:
     [SKAction sequence:@[
                          [SKAction waitForDuration:0.5],[SKAction runBlock:^{
         //5
         SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
         SKScene *myScene = [[MyScene alloc]initWithSize:self.size];
         [self.view presentScene:myScene transition:reveal];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"closeScene" object:nil];
         NSLog(@"Exit");

     }]
                          ]]
     ];
    
}

@end
