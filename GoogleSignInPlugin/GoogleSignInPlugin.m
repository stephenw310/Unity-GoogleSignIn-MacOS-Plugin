//
//  GoogleSignInPlugin.m
//  GoogleSignInPlugin
//
//  Created by Chao Wu on 2/5/24.
//

#import "GoogleSignInPlugin.h"
#import <GoogleSignIn.h>

@implementation GoogleSignInPlugin

static GoogleSignInPlugin *shared = nil;

+ (GoogleSignInPlugin *)sharedInstance {
    if (shared == nil) {
        shared = [[GoogleSignInPlugin alloc] init];
    }
    return shared;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Register for GetURL events.
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self
                           andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                         forEventClass:kInternetEventClass
                            andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
           withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString *URLString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSURL *URL = [NSURL URLWithString:URLString];
    [GIDSignIn.sharedInstance handleURL:URL];
}

- (NSString*) serializeToJsonString: (NSDictionary*) dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void) SignIn:(UnityCallback) callback{
    [GIDSignIn.sharedInstance
     signInWithPresentingWindow:[[[NSApplication sharedApplication] windows] objectAtIndex:0]
     completion:^(GIDSignInResult * _Nullable signInResult,
                  NSError * _Nullable error) {
        NSString *jsonString;
        if (error) {
            NSLog(@"Google SignIn Error: %ld, %@", error.code, error.description);
            NSDictionary *errorDictionary = @{
                @"success" : @NO,
                @"errorCode" : @(error.code),
                @"errorMessage": error.localizedDescription};
            
            jsonString = [self serializeToJsonString:errorDictionary];
        }
        else {
            NSMutableDictionary *jsonDictionary = [@{
                @"success" : @YES,
                @"accessToken": signInResult.user.accessToken.tokenString,
                @"refreshToken": signInResult.user.refreshToken.tokenString,
            } mutableCopy];
            
            if (signInResult.user.userID) jsonDictionary[@"userId"] = signInResult.user.userID;
            if (signInResult.user.profile.email) jsonDictionary[@"email"] = signInResult.user.profile.email;
            if (signInResult.user.profile.name) jsonDictionary[@"name"] = signInResult.user.profile.name;
            if (signInResult.user.idToken.tokenString) jsonDictionary[@"idToken"] = signInResult.user.idToken.tokenString;
            if (signInResult.serverAuthCode) jsonDictionary[@"serverAuthCode"] = signInResult.serverAuthCode;
            
            NSLog(@"Google SignIn Success: %@", jsonDictionary);
            
            jsonString = [self serializeToJsonString:jsonDictionary];
            NSLog(@"Serialized success result: %@", jsonString);
        }
        callback(strdup([jsonString UTF8String]));
    }];
}

@end

#ifdef __cplusplus
extern "C"
{
#endif
    void _signIn(UnityCallback callbackFunc) {
        [[GoogleSignInPlugin sharedInstance] SignIn:callbackFunc];
    }
#ifdef __cplusplus
}
#endif
