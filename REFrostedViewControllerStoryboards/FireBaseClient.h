//
//  FireBaseClient.h
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/23/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface FireBaseClient : NSObject

@property (strong, nonatomic) Firebase* ref;

-(void) createUserAccountStore:(NSString *)userFirstName andLastName:(NSString *)userLastName;
-(void) getUserAccountStore:(NSString *)userFirstName;

@end
