//
//  AppDelegate.m
//  HackerNews
//
//  Created by Daniel on 4/1/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

@import CoreData;

#import "AppDelegate.h"
#import "HNFeedViewModel.h"
#import "HNFeedViewController.h"
#import "UIColor+HNColorPalette.h"
#import "UIFont+HNFont.h"


#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HNItemDataManager.h"
#import "HNNetworkService.h"
#import "HNComment.h"
#import "HNItemComment.h"
#import "HNCommentThread.h"
#import "HNDataManager.h"


@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    HNFeedViewController *feedController = (HNFeedViewController *)navController.topViewController;
    feedController.viewModel = [HNFeedViewModel new];
    
    [[UINavigationBar appearance] setTintColor:[UIColor HNOrange]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightSemibold size:18.0], NSForegroundColorAttributeName : [UIColor HNOrange]}];

    
//    [[[[HNItemDataManager sharedManager] threadForRootCommentID:@9442381] collect] subscribeNext:^(HNCommentThread *y) {
//        NSLog(@"NEXT:%@",y);
//    }];
//
    
   [[[[[[[[HNItemDataManager sharedManager]testStory] flattenMap:^RACStream *(id value) {
        return [[HNItemDataManager sharedManager] rootCommentForStory:value];
    }] collect] logNext] flattenMap:^RACStream *(NSArray *rootComments) {
        return [[rootComments.rac_sequence flattenMap:^RACStream *(HNItemComment *value) {
            
//             return [RACSignal if:[RACSignal return:@(value.kids != nil)]
//                                               then:[[RACSignal return:[self repliesForRootComment:value]] concat]
//                                               else:[RACSignal return:value]];
            
            if (value.kids != nil) {
                return [self repliesForRootComment:value].sequence;
            } else {
                return [RACSignal return:value].sequence;
            }
        }] signal];
    }] logNext]
    
    subscribeNext:^(id x) {
        DLogNSObject([x replies]);
    } error:^(NSError *error) {
        DLogNSObject(error);
    } completed:^{
        DLogFunctionLine();
    }];
      
      
      
      
      
//      flattenMap:^RACStream *(HNItemComment *value) {
//        
//        return [RACSignal defer:^RACSignal *{
//            return [RACSignal if:[RACSignal return:@(value.kids != nil)]
//                    then:[[RACSignal return:[self repliesForRootComment:value]] concat]
//                    else:[RACSignal return:value]];
//
//        }];
//    }] map:^id(id value) {
//        DLogNSObject(value);
////        DLogNSInteger([[value replies] count]);
////        DLogNSObject([value idNum]);
//        return value;
//    }] subscribeNext:^(id x) {
////        DLogNSObject([x idNum]);
//    } error:^(NSError *error) {
//        DLogNSObject(error);
//    } completed:^{
//        DLogFunctionLine();
//    }];

    
//    @weakify(self);
//    [[[testStory map:^id(HNItemComment *rootComment) {
////        DLogNSObject(rootComment.idNum);
//
//        
//        return [RACSignal if:[RACSignal return:@NO]
//                
//                then:[self repliesForRootComment:rootComment]
//                
//                else:[RACSignal return:rootComment]];
//        
//        
////       [self repliesForRootComment:rootComment] 
//    }] map:^id(HNItemComment *x) {
//        DLogNSObject([x idNum]);
//        return x;
//    }] subscribeNext:^(HNItemComment *x) {
////        DLogNSObject(x.idNum);
//    }  error:^(NSError *error) {
//        DLogNSObject(error);
//    }  completed:^{
//        DLogFunctionLine();
//    }];
    
    return YES;
}


- (RACSignal *)repliesForRootComment:(HNItemComment *)rootComment {
    
    return [[[[[rootComment.kids.rac_sequence.eagerSequence
                 map:^id(id value) {
                    return [[HNItemDataManager sharedManager]commentForID:value];
                }] signal] flatten]
             doNext:^(HNItemComment *reply) {
                 [rootComment.replies addObject:reply];
              }]
             then:^RACSignal *{
                return [RACSignal return:rootComment];
             }];
//
//    return [RACSignal return:rootComment];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[[HNDataManager sharedManager] coreDataStack] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[[HNDataManager sharedManager] coreDataStack] saveContext];
}

@end
