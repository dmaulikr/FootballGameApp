//
//  GCHelper.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 22/01/15.
//  Copyright (c) 2015 Ernesto Sánchez Kuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface GCHelper : NSObject{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    AppDelegate *appDelegate;
}

@property (assign, readonly) BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUserInController:(UIViewController *)controller;

@end
