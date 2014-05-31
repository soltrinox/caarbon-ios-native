//
//  DEMOHomeViewController.h
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

#import "MVSpeechSynthesizer.h"


#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@interface MainHomeViewController : UIViewController

- (IBAction)showMenu;

@property (strong, nonatomic) Firebase* ref;
@property (strong, nonatomic)  FirebaseSimpleLogin* authClient;



@end
