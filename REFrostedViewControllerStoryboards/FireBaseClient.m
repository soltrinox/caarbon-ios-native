//
//  FireBaseClient.m
//  REFrostedViewControllerStoryboards
//
//  Created by Dylan Rosario on 5/23/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "FireBaseClient.h"

@implementation FireBaseClient


-(void) createUserAccountStore:(NSString *)userFirstName andLastName:(NSString *)userLastName{

	_ref = [[Firebase alloc] initWithUrl:@"https://flickering-fire-6332.firebaseio.com/"];
	Firebase* usersRef = [_ref childByAppendingPath:@"users"];

	//parent ref ??
	Firebase* parentRef = [usersRef parent];

	NSString *user = [NSString stringWithFormat:@"users/%@/name",userFirstName];
	Firebase* newUserNameRef = [usersRef childByAppendingPath:user];

	// messagelist ???
	Firebase* messageListRef = [newUserNameRef.parent.parent childByAppendingPath:@"message_list"];

	// add first and last name for user
	[newUserNameRef setValue:@{@"first": userFirstName, @"last":  userLastName } withCompletionBlock:^(NSError *error, Firebase* ref) {
		if(error) {
			NSLog(@"Data could not be saved: %@", error);
		} else {
			NSLog(@"Data saved successfully.");
		}
	}];

}


-(void) getUserAccountStore:(NSString *)userFirstName {

	NSString* url = [NSString stringWithFormat:@"https://flickering-fire-6332.firebaseio.com/users/%@/name", userFirstName];
	Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
	[dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

		for (FDataSnapshot* child in snapshot.children) {
			NSLog(@"%@ : %@", child.name,  child.value );
		}
	}];
}



@end
