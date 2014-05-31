//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "MainHomeViewController.h"
#import "MVSpeechSynthesizer.h"
#import "FireBaseClient.h"
#import "NSStringAdditions.h"
#import "VBFDownloadButton.h"
#import "VBFPopUpMenu.h"

@interface MainHomeViewController ()

@property(nonatomic,weak)IBOutlet UITextView *sampleTextview;
@property(nonatomic,weak)IBOutlet UIButton *readButton;
@property(nonatomic,weak)IBOutlet UIBarButtonItem *languageButton;
@property(nonatomic,weak)IBOutlet UILabel *infoLabel;
@property(nonatomic,weak)IBOutlet UIView *helpView;
@property(nonatomic,weak)IBOutlet UITextView *helpTextView;
@property(nonatomic,strong)NSString *language;
-(IBAction)startRead:(id)sender;
-(IBAction)languagePress:(id)sender;
-(IBAction)skipPress:(id)sender;

@end

@implementation MainHomeViewController



- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (void) viewDidLoad {
	[super viewDidLoad];

	[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                     forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.view.backgroundColor = [UIColor clearColor];

	_ref = [[Firebase alloc] initWithUrl:@"https://flickering-fire-6332.firebaseio.com/"];
	_authClient = [[FirebaseSimpleLogin alloc] initWithRef:_ref];

	[self.view addSubview:_sampleTextview];
	[self.view addSubview:_helpTextView];

//	FireBaseClient* fbc;
	[self createUserAccountStore:@"Dylan" andLastName:@"Rosario"];
	[self getUserAccountStore:@"Dylan"];


	// read aloud
	_infoLabel.lineBreakMode=YES;
    _infoLabel.numberOfLines=0;

    _sampleTextview.text=@"Welcome to Carbon . Please log in to carbon when you are ready.  If you are a new user select the join button below. ";
	[self readText:_sampleTextview.text];
[self addControls];

}



#pragma mark - textview delegate method
- (void)textViewDidChange:(UITextView *)textView{
     MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.speechLanguage=nil;
    _infoLabel.text=@"";
}


-(void)readText:(NSString *)readText {

    [_languageButton setEnabled:NO];
    MVSpeechSynthesizer *mvSpeech=[MVSpeechSynthesizer sharedSyntheSize];
    mvSpeech.inputView=_sampleTextview;
    mvSpeech.higlightColor=[UIColor yellowColor];
    mvSpeech.isTextHiglight=YES;
    mvSpeech.speechString=readText;
    NSString *speechLanguage=mvSpeech.speechLanguage;
    [mvSpeech startRead];
   
    mvSpeech.speechStartBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
        // you can change the accent of the digital assistant
        NSLog(@"speech language==%@",speechLanguage);
        NSArray *tempArray=[speechLanguage componentsSeparatedByString:@"-"];
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject:tempArray[1] forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        NSLocale *enLocale =[[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        NSString *displayNameString = [enLocale displayNameForKey:NSLocaleIdentifier value:tempArray[0]];
        _infoLabel.text=[NSString stringWithFormat:@"Language : %@ \nCountry    : %@",displayNameString,country];
        
	};
        
    mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
		// do something here
    };

	//   use this to stop the speach from an override button
	//   [mvSpeech stopReading];

    
}




-(void) createUserAccount{

	[_authClient createUserWithEmail:@"email@domain.com" password:@"very secret"
		andCompletionBlock:^(NSError* error, FAUser* user) {

			if (error != nil) {
			// There was an error creating the account
			} else {
			// We created a new user account
			}
	}];

}

-(void) authUserAccount{
	[_authClient loginWithEmail:@"email@domain.com" andPassword:@"very secret"
    withCompletionBlock:^(NSError* error, FAUser* user) {

		if (error != nil) {
        // There was an error logging in to this account
		} else {
        // We are now logged in
		}
	}];
}

-(void) changePassword{
	[_authClient changePasswordForEmail:@"email@domain.com" oldPassword:@"very secret"
    newPassword:@"very very secret" completionBlock:^(NSError* error, BOOL success) {

		if (error != nil) {
        // There was an error processing the request
		} else if (success) {
        // Password changed successfully
		}
	}];
}

-(void) sendPasswordReset{
	[_authClient sendPasswordResetForEmail:@"email@domain.com" andCompletionBlock:^(NSError* error, BOOL success) {

    if (error != nil) {
        // There was an error processing the request
    } else if (success) {
        // Password reset email sent successfully
    }
	}];
}

-(void) deleteUser{
	[_authClient removeUserWithEmail:@"email@domain.com" password:@"very secret"
    andCompletionBlock:^(NSError* error, BOOL success) {

		if (error != nil) {
        // There was an error processing the request
		} else if (success) {
        // User deleted successfully
		}
	}];
}

-(void) createUserAccountStore:(NSString *)userFirstName andLastName:(NSString *)userLastName{

	_ref = [[Firebase alloc] initWithUrl:@"https://flickering-fire-6332.firebaseio.com/"];
	//Firebase* usersRef = [_ref childByAppendingPath:@"users"];

	//parent ref ??
	//Firebase* parentRef = [usersRef parent];

	NSString *user = [NSString stringWithFormat:@"users/%@/name",userFirstName];
	Firebase* newUserNameRef = [_ref childByAppendingPath:user];

	// messagelist ???
	//Firebase* messageListRef = [newUserNameRef.parent.parent childByAppendingPath:@"message_list"];

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

//   ******************** NOTE ************
//     you can probably do this class polymorphic and create a new method with just an image vs a source imageview
//   -(void) addImageToFireBase:(UIImage *)inImage andImageName:(NSString *)imgName andUserName:(NSString *)userName{

-(void) addImageToFireBase:(UIImageView *)inImageView andImageName:(NSString *)imgName andUserName:(NSString *)userName{

	UIImage *uploadImage = inImageView.image;
	NSData *imageData = UIImageJPEGRepresentation(uploadImage, 0.9);
 
	// using base64StringFromData method, we are able to convert data to string
	NSString *imageString = [NSString base64StringFromData:imageData length:[imageData length]];

	NSString *userImage = [NSString stringWithFormat:@"users/%@/image",userName];

	_ref = [[Firebase alloc] initWithUrl:@"https://flickering-fire-6332.firebaseio.com/"];
	Firebase* firebaseImageRef = [_ref childByAppendingPath:userImage];

	[firebaseImageRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        long dataLength = snapshot.childrenCount;
        NSString *indexPath = [NSString stringWithFormat: @"%ld", dataLength];
        Firebase* newImageRef = [firebaseImageRef childByAppendingPath:indexPath];
        [newImageRef setValue:@{@"image": imageString, @"someObjectId": imgName}];
	}];
}


- (void) addControls {
    //Download control
    
    UIView *secondView = self.view;
    NSArray *icons = @[[UIImage imageNamed:@"twitterIcon"],[UIImage imageNamed:@"facebookIcon"],[UIImage imageNamed:@"dribbbleIcon"],[UIImage imageNamed:@"downloadIcon"]];
    
    VBFPopUpMenu *popUp = [[VBFPopUpMenu alloc]initWithFrame:self.view.frame
                                                   direction:M_PI
                                                   iconArray:icons];
    [self.view addSubview:popUp];
}


@end