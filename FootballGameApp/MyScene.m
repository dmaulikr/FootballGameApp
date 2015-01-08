//
//  MyScene.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 09/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "MyScene.h"
#import "GameOverScene.h"
#import "FGUtilities.h"

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t defenderCategory        =  0x1 << 1;
static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}
// 1
@interface MyScene ()
@property (nonatomic) NSInteger numberOfDefenders;
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) SKLabelNode *scoreTitleLabel;
@property (nonatomic) SKLabelNode *ballsUsedLabel;
@property (nonatomic) SKLabelNode *levelLabel;
@property (nonatomic) SKLabelNode *scoreNumberLabel;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSInteger defenderDefeated;
@property (nonatomic) NSInteger levelNumber;
@property (nonatomic) NSInteger numberOfBallsUsed;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 2
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        self.playerColor = [[FGUtilities sharedInstance]vcObject].playerColor;
        
        // 3
        self.backgroundColor = [SKColor clearColor];
        SKSpriteNode *backgroundImage = [SKSpriteNode spriteNodeWithImageNamed:@"footbalField"];
        //backgroundImage.size = CGSizeMake(self.size.height, self.size.width);
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backgroundImage];
        
        
        
        // 4
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"bluePlayer"];

        NSDictionary *dictColor = @{
                                    @"blue":^{
                                        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"bluePlayer"];
                                    },
                                    @"green": ^{
                                        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"greenPlayer"];
                                    },@"red": ^{
                                        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"redPlayer"];
                                    },@"yellow": ^{
                                        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"yellowPlayer"];
                                    },
        };
        ((PlayerColorBlock)dictColor[self.playerColor])();
        
        self.player.position = CGPointMake(20, (self.size.height/2) - (self.player.size.height / 2));
        [self addChild:self.player];
        
        self.scoreTitleLabel = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue"];
        [self.scoreTitleLabel setPosition:CGPointMake(self.size.width - 100, 10)];
        [self.scoreTitleLabel setFontSize:20];
        [self.scoreTitleLabel setText:@"Score"];
        [self addChild:self.scoreTitleLabel];
        
        self.scoreNumberLabel = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue"];
        [self.scoreNumberLabel setPosition:CGPointMake(self.size.width - 50, 10)];
        [self.scoreNumberLabel setFontSize:20];
        self.levelLabel = [[SKLabelNode alloc]initWithFontNamed:@"HelveticaNeue"];
        [self.levelLabel setPosition:CGPointMake(50, 300)];
        [self.levelLabel setFontSize:20];
        self.levelNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"level"];
        if (self.levelNumber < 2) {
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"currentScore"];
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"ballsUsed"];
        }
        [self.levelLabel setText:[NSString stringWithFormat:@"Level %ld", (long)self.levelNumber]];
        [self addChild:self.levelLabel];
        NSInteger currentScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentScore"];
        if (currentScore > 0) {
            self.defenderDefeated = currentScore;
        }else{
            self.defenderDefeated = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentScore"];
        }
        
        [self.scoreNumberLabel setText:[NSString stringWithFormat:@"%ld",(long)self.defenderDefeated]];
        [self addChild:self.scoreNumberLabel];

        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        
        
    }
    return self;
}




-(void)addDefenders:(NSInteger)defenders
{
    self.opponentColor =[[FGUtilities sharedInstance]vcObject].opponentColor;
    if (!self.opponentColor) {
        self.opponentColor = @"blue";
    }
    //Create Sprite
    for (int x = 0; x<defenders; x++) {
        __block SKSpriteNode *defender;
    
        NSDictionary *dictColor = @{
                                    @"blue":^{
                                        defender = [SKSpriteNode spriteNodeWithImageNamed:@"blueDefender"];
                                    },
                                    @"green": ^{
                                        defender = [SKSpriteNode spriteNodeWithImageNamed:@"greenDefender"];
                                    },@"red": ^{
                                        defender = [SKSpriteNode spriteNodeWithImageNamed:@"redDefender"];
                                    },@"yellow": ^{
                                        defender = [SKSpriteNode spriteNodeWithImageNamed:@"yellowDefender"];
                                    },
                                    };
        if (self.opponentColor) {
            ((OpponentColorBlock)dictColor[self.opponentColor])();
        }
        
       
        defender.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:defender.size];
        defender.physicsBody.dynamic = YES;
        defender.physicsBody.categoryBitMask = defenderCategory;
        defender.physicsBody.contactTestBitMask = projectileCategory;
        defender.physicsBody.collisionBitMask = 0;
        //Determine where to spawm the defender along the Y axis
        
        int minY = defender.size.height / 2;
        int maxY = self.frame.size.height - defender.size.height / 2;
        int rangeY = maxY - minY;
        int actualY = (arc4random() % rangeY) + minY;
        
        // Create the defender slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        defender.position = CGPointMake(self.frame.size.width + defender.size.width / 2, actualY);
        [self addChild:defender];
        
        //Determine speed of the defender
        int minDuration = 2.0;
        int maxDuration = 4.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        
        //Actions
        SKAction *actionMove = [SKAction moveTo:CGPointMake(-defender.size.width / 2, actualY) duration:actualDuration];
        SKAction *actionMoveDone = [SKAction removeFromParent];
        SKAction *loseAction = [SKAction runBlock:^{
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [[NSUserDefaults standardUserDefaults]setInteger:self.numberOfBallsUsed forKey:@"ballsUsed"];
            [[NSUserDefaults standardUserDefaults]setInteger:self.defenderDefeated forKey:@"currentScore"];
            float accuracyPercentage = (self.defenderDefeated != 0) ? ((float)self.defenderDefeated / (float)self.numberOfBallsUsed) : 0.0f;
            float bonus =  accuracyPercentage + 1.0f;
             int accuracyBonus = self.defenderDefeated * bonus;
            [[NSUserDefaults standardUserDefaults]setFloat:accuracyPercentage forKey:@"accuracyPercentage"];
            [[NSUserDefaults standardUserDefaults]setInteger:accuracyBonus forKey:@"accuracyBonus"];
            
            
            SKScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size won:NO];
            [self.view presentScene:gameOverScene transition:reveal];
        }];
        [defender runAction:[SKAction sequence:@[actionMove,loseAction, actionMoveDone]]];
    }
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        self.difficulty = [[FGUtilities sharedInstance]vcObject].difficulty;
        
        /*switch (self.difficulty) {
            case 1:
            {
                self.numberOfDefenders = 1;
                break;
            }
            case 2:
            {
                self.numberOfDefenders = 2;
                break;
            }
            case 3:
            {
                self.numberOfDefenders = 3;
                break;
            }
            default:
                self.numberOfDefenders = 1;
                break;
        }*/
        self.numberOfDefenders = [[NSUserDefaults standardUserDefaults]integerForKey:@"defenders#"];
        [self addDefenders:self.numberOfDefenders];
     
        
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    //Handle Time Delta
    //If we draw below 60 fps we still want everything moving the same distance
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
   /* for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }*/
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self runAction:[SKAction playSoundFileNamed:@"bounce.mp3" waitForCompletion:NO]];
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // 2 - Set up initial location of projectile
    SKSpriteNode * projectile = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    projectile.position = self.player.position;
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = defenderCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    
    // 3- Determine offset of location to projectile
    CGPoint offset = rwSub(location, projectile.position);
    
    // 4 - Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // 5 - OK to add now - we've double checked position
    [self addChild:projectile];
    
    // 6 - Get the direction of where to shoot
    CGPoint direction = rwNormalize(offset);
    
    // 7 - Make it shoot far enough to be guaranteed off screen
    CGPoint shootAmount = rwMult(direction, 1000);
    
    // 8 - Add the shoot amount to the current position
    CGPoint realDest = rwAdd(shootAmount, projectile.position);
    
    // 9 - Create the actions
    float velocity = 480.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    SKAction *rotateAction = [SKAction rotateByAngle:M_PI duration:2];
    
    [projectile runAction:[SKAction sequence:@[actionMove, actionMoveDone, rotateAction]]];
    ++self.numberOfBallsUsed;
    
}

-(void)projectile:(SKSpriteNode *)projectile didCollideWithDefender:(SKSpriteNode *)defender
{
    NSLog(@"Hit");
    [projectile removeFromParent];
    [defender removeFromParent];
    self.defenderDefeated++;
    [self.scoreNumberLabel setText:[NSString stringWithFormat:@"%ld",(long)self.defenderDefeated]];
    NSInteger currentLevel = [[NSUserDefaults standardUserDefaults]integerForKey:@"level"];
    if (self.defenderDefeated > (currentLevel * 20)) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size won:YES];
        [[NSUserDefaults standardUserDefaults]setInteger:self.defenderDefeated forKey:@"currentScore"];
       
        
        
        [self.view presentScene:gameOverScene transition:reveal];
    }
}

-(SKLabelNode *)pauseButton
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
    label.text = @"Pause";
    label.fontSize = 20;
    label.fontColor = [SKColor blackColor];
    label.position = CGPointMake(self.size.width - 50, 300);
    label.userInteractionEnabled = YES;
    
    return label;
}



-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //1
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    //2
    if ((firstBody.categoryBitMask & projectileCategory) != 0 && (secondBody.categoryBitMask & defenderCategory) != 0) {
        [self projectile:firstBody.node didCollideWithDefender:secondBody.node];
    }
}

-(void)pauseGame
{
    self.paused = YES;
}
-(void)unpauseGame
{
    self.paused = NO;
}


@end
