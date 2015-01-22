//
//  GCHelper.m
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 22/01/15.
//  Copyright (c) 2015 Ernesto Sánchez Kuri. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper
@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;

+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
    
}

- (void)authenticateLocalUserInController:(UIViewController *)controller {
    
    NSLog(@"Authenticating local user ...");
    if(!gameCenterAvailable) {
        return;
    }
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        NSLog(@"authenticateHandler");
        if (viewController != nil)
        {
            NSLog(@"viewController != nil");
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            [controller presentViewController:viewController animated:YES completion:nil];
        }
        else if ([GKLocalPlayer localPlayer].isAuthenticated)
        {
            NSLog(@"localPlayer already authenticated");
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
           // [self authenticatedPlayer: localPlayer];
        }
        else
        {
            NSLog(@"local player not authenticated");
            
            //[self disableGameCenter];
        }
    };
}

@end
