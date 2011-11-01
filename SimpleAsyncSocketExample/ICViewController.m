//
//  ICViewController.m
//  SimpleAsyncSocketExample
//
//  Created by Ignazio Calò on 11/1/11.
//  Copyright (c) 2011 Ignazio Calò. All rights reserved.
//

#import "ICViewController.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ICViewController
@synthesize serverAddr;
@synthesize serverPort;
@synthesize bufOut;
@synthesize bufIn;



- (void)dealloc {
    [serverAddr release];
    [serverPort release];
    [bufOut release];
    [bufIn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setServerAddr:nil];
    [self setServerPort:nil];
    [self setBufOut:nil];
    [self setBufIn:nil];
    [super viewDidUnload];
}
- (IBAction)performConnection:(id)sender {
	NSLog(@"PROVO...");
	asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];	
	NSError *error = nil;
	uint16_t port = [[[self serverPort] text] intValue];
	
	if (![asyncSocket connectToHost:[serverAddr text] onPort:port error:&error])
	{
		DDLogError(@"Unable to connect to due to invalid configuration: %@", error);
		[self debugPrint:[NSString stringWithFormat:@"Unable to connect to due to invalid configuration: %@", error]];
	}
	else
	{
		DDLogVerbose(@"Connecting...");
	}	
}

- (IBAction)sendBuf:(id)sender {
	if ([[bufOut text] length] > 0) {
		NSString *requestStr = [bufOut text];
		NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
		[asyncSocket writeData:requestData withTimeout:-1.0 tag:0];
		[self debugPrint:[NSString stringWithFormat:@"Sent:  \n%@",requestStr]];
	}
	[self startRead];
}


-(void)startRead {
	//[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startRead) userInfo:nil repeats:YES];
	[asyncSocket readDataWithTimeout:-1 tag:0];
}

- (void)debugPrint:(NSString *)text {
	[bufIn setText:text];
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	DDLogVerbose(@"socket:didConnectToHost:%@ port:%hu", host, port);
	[self debugPrint:[NSString stringWithFormat:@"socket:didConnectToHost:%@ port:%hu", host, port]];
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	DDLogVerbose(@"socket:didWriteDataWithTag:");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	DDLogVerbose(@"socket:didReadData:withTag:");
	
	NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	[self debugPrint:[NSString stringWithFormat:@"Read:  \n%@",response]];
	[response release];
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{	
	DDLogVerbose(@"socketDidDisconnect:withError: \"%@\"", err);
	[self debugPrint:[NSString stringWithFormat:@"socketDidDisconnect:withError: \"%@\"", err]];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
