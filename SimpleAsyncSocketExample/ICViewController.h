//
//  ICViewController.h
//  SimpleAsyncSocketExample
//
//  Created by Ignazio Calò on 11/1/11.
//  Copyright (c) 2011 Ignazio Calò. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;
@interface ICViewController : UIViewController <UITextFieldDelegate>{
    
	UITextField *serverAddr;
	UITextField *serverPort;
	UITextField *bufOut;
	UITextView *bufIn;
	
	GCDAsyncSocket *asyncSocket;
}
@property (nonatomic, retain) IBOutlet UITextField *serverAddr;
@property (nonatomic, retain) IBOutlet UITextField *serverPort;
@property (nonatomic, retain) IBOutlet UITextField *bufOut;
@property (nonatomic, retain) IBOutlet UITextView *bufIn;


- (IBAction)performConnection:(id)sender;
- (IBAction)sendBuf:(id)sender;
- (void)debugPrint:(NSString *)text;
-(void)startRead;
@end
