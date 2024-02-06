//
//  GoogleSignInPlugin.h
//  GoogleSignInPlugin
//
//  Created by Chao Wu on 2/5/24.
//

#import <Foundation/Foundation.h>

typedef void (*UnityCallback)(char * message);

@interface GoogleSignInPlugin : NSObject

- (void) SignIn:(UnityCallback) callback;

@end
