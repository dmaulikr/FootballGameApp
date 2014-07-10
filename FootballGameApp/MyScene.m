//
//  MyScene.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 09/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import "MyScene.h"
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
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        // 2
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        // 3
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // 4
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(20, 140);
        [self addChild:self.player];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}

-(void)addDefender
{
    //Create Sprite
    SKSpriteNode *defender = [SKSpriteNode spriteNodeWithImageNamed:@"defender"];
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
    [defender runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 1) {
        self.lastSpawnTimeInterval = 0;
        [self addDefender];
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
    
}

-(void)projectile:(SKSpriteNode *)projectile didCollideWithDefender:(SKSpriteNode *)defender
{
    NSLog(@"Hit");
    [projectile removeFromParent];
    [defender removeFromParent];
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


@end
