//
//  FGUtilities.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 22/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface FGUtilities : NSObject

+(id)sharedInstance;
@property (nonatomic,strong)NSDictionary *userPreferences;
@property (nonatomic, strong)ViewController *vcObject;
@end
