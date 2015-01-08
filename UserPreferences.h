//
//  UserPreferences.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 23/07/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserPreferences : NSManagedObject

@property (nonatomic, retain) NSString * difficulty;
@property (nonatomic, retain) NSString * sound;
@property (nonatomic, retain) NSString * playerColor;
@property (nonatomic, retain) NSString * opponentColor;

@end
