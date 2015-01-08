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

@implementation GameOverScene

-(id)initWithSize:(CGSize)size won:(BOOL)won
{
    if (self = [self initWithSize:size]) {
        //1
        self.backgroundColor = [SKColor colorWithRed:158.0f/255.0f green:229.0f/255.0f blue:88.0f/255.0f alpha:1];
        //2
        NSString *message;
        NSString *accuracyMessage;
        NSString *finalScoreMessage;
        if (won) {
            NSInteger defaultLevel= [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
            defaultLevel++;
            [[NSUserDefaults standardUserDefaults]setInteger:defaultLevel forKey:@"level"];
            NSInteger currentLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"defenders#"];
            currentLevel++;
            [[NSUserDefaults standardUserDefaults]setInteger:currentLevel forKey:@"defenders#"];
            message = [NSString stringWithFormat:@"Level %ld", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"level"]];
            [self runAction:[SKAction playSoundFileNamed:@"cheerCrowd.mp3" waitForCompletion:NO]];
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
            NSInteger currentScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentScore"];
            NSInteger accuracy = 100 *  [[NSUserDefaults standardUserDefaults] floatForKey:@"accuracyPercentage"];
           NSInteger finalScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"accuracyBonus"];
            
            
            message =[NSString stringWithFormat:@"You defeated %ld defenders", (long)currentScore];
            accuracyMessage = [NSString stringWithFormat:@"Your accuracy was of %ld %%", (long)accuracy];
            finalScoreMessage = [NSString stringWithFormat:@"Your final score is: %ld", (long)finalScore];
            
            [self runAction:[SKAction playSoundFileNamed:@"booCrowd.mp3" waitForCompletion:NO]];
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            label.text = message;
            label.fontSize = 30;
            label.fontColor = [SKColor blackColor];
            label.position = CGPointMake(self.size.width / 2, self.size.height/2 - 20);
            [self addChild:label];
            
            SKLabelNode *accuracyLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            accuracyLabel.text = accuracyMessage;
            accuracyLabel.fontSize = 30;
            accuracyLabel.fontColor = [SKColor blackColor];
            accuracyLabel.position = CGPointMake(self.size.width / 2, (label.frame.origin.y + label.frame.size.height + 10));
            [self addChild:accuracyLabel];
            
            SKLabelNode *finalScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            finalScoreLabel.text = finalScoreMessage;
            finalScoreLabel.fontSize = 30;
            finalScoreLabel.fontColor = [SKColor blackColor];
            finalScoreLabel.position = CGPointMake(self.size.width / 2, (accuracyLabel.frame.origin.y + accuracyLabel.frame.size.height + 10));
            [self addChild:finalScoreLabel];
            
            
            
            SKLabelNode *playAgain = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            
            SKShapeNode *circleNode = [[SKShapeNode alloc]init];
            circleNode.name = @"playAgainNode";
            circleNode.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-120, -20, 250, 60)].CGPath;
            circleNode.fillColor = [SKColor clearColor];
            circleNode.lineWidth = 2;
            circleNode.strokeColor = [SKColor blackColor];
            
            
            [playAgain setText:@"Play Again"];
            playAgain.fontColor = [SKColor blackColor];
            playAgain.position = CGPointMake(self.size.width /2, self.size.height / 1.2);
            [playAgain addChild:circleNode];
            [self addChild:playAgain];
            
            
            
            
            SKLabelNode *menuLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
            [menuLabel setText:@"Exit"];
            menuLabel.fontColor = [SKColor blackColor];
            menuLabel.position = CGPointMake(self.size.width /2, 30);
            [self addChild:menuLabel];
            SKShapeNode *exitCircleNode = [[SKShapeNode alloc]init];
            exitCircleNode.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-120, -20, 250, 60)].CGPath;
            exitCircleNode.name = @"exitNode";
            exitCircleNode.fillColor = [SKColor clearColor];
            exitCircleNode.lineWidth = 2;
            exitCircleNode.strokeColor = [SKColor blackColor];
            [menuLabel addChild:exitCircleNode];
            [[NSUserDefaults standardUserDefaults]setFloat:0.0f forKey:@"accuracyPercentage"];
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"accuracyBonus"];
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

        }
    }
    
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