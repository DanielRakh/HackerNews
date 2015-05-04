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
#import "HNDataManager.h"
#import "HNNetworkService.h"
#import "HNComment.h"
#import "HNItemComment.h"
#import "HNCommentThread.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    [[HNDataManager sharedManager] testCommentsForItem:@(9382933)];
    
    
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    HNFeedViewController *feedController = (HNFeedViewController *)navController.topViewController;
    feedController.viewModel = [HNFeedViewModel new];
    
    
    
    [[UINavigationBar appearance] setTintColor:[UIColor HNOrange]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName : [UIFont proximaNovaWithWeight:TypeWeightSemibold size:18.0], NSForegroundColorAttributeName : [UIColor HNOrange]}];

    
//    [[self threadForRootComment:@9442381] subscribeNext:^(HNItemComment *x) {
//        NSLog(@"NEXT:%@",x);
//    } error:^(NSError *error) {
//        NSLog(@"ERROR:%@",error);
//    } completed:^{
//        NSLog(@"COMPLETED!");
//    }];
//
//    
    
    [[self threadForRootCommentID:@9442381] subscribeNext:^(HNCommentThread *x) {
        NSLog(@"%@",x);
    }];
    
    
    



    return YES;
}


- (RACSignal *)populateRepliesForRootComment:(HNItemComment *)comment {
    
   return [[comment.kids.rac_sequence.signal flattenMap:^RACStream *(id value) {
        return [[[self comment:value]
                doNext:^(HNItemComment *child) {
                    [comment.replies addObject:child];
                }] flattenMap:^RACStream *(HNItemComment *child) {
                    if (child.kids.count > 0) {
                        return [self populateRepliesForRootComment:child];
                    } else {
                        return [RACSignal empty];
                    }
                }];
    }] then:^RACSignal *{
//        return [[self threadForComment:comment] flattenMap:^RACStream *(HNCommentThread *thread) {
//            return [self populateThreadForRootThread:thread];
//        }];
        return [RACSignal return:comment];
    }];
    
}


- (RACSignal *)populateThreadForRootThread:(HNCommentThread *)thread {
    
    return [[thread.headComment.replies.rac_sequence.signal flattenMap:^RACStream *(HNItemComment *reply) {
        return [[[self threadForComment:reply]
                doNext:^(HNCommentThread *replyThread) {
                    [thread addReply:replyThread];
                }] flattenMap:^RACStream *(HNCommentThread *replyThread) {
                    if (replyThread.headComment.replies.count > 0) {
                        return [self populateThreadForRootThread:replyThread];
                    } else {
                        return [RACSignal empty];
                    }
                }];
    }] then:^RACSignal *{
        return [RACSignal return:thread];
    }];
    
}

- (RACSignal *)threadForRootCommentID:(NSNumber *)commentID {
    return [[self comment:commentID] flattenMap:^RACStream *(HNItemComment *rootComment) {
        return [[self populateRepliesForRootComment:rootComment] flattenMap:^RACStream *(HNItemComment *comment) {
            return [[self threadForComment:comment] flattenMap:^RACStream *(HNCommentThread *thread) {
                return [self populateThreadForRootThread:thread];
            }];
        }];
    }];
}


- (RACSignal *)comment:(NSNumber *)idNum {
    
    return [[[HNNetworkService sharedManager]valueForItem:idNum] map:^id(NSDictionary *dict) {
        HNItemComment *comment = [HNItemComment new];
        comment.idNum = dict[@"id"];
        comment.kids = dict[@"kids"];
        return comment;
    }];
    
}


- (RACSignal *)threadForComment:(HNItemComment *)comment {
    HNCommentThread *thread = [HNCommentThread threadWithTopComment:comment replies:nil];
    return [RACSignal return:thread];
}



- (NSMutableArray *)threadForHeadComment:(HNItemComment *)comment {

    NSMutableArray *replyArray = [NSMutableArray array];

    for (HNItemComment *reply in comment.replies) {

        HNCommentThread *thread = [HNCommentThread threadWithTopComment:reply
                                                               replies:reply.replies.count == 0 ? nil : [self threadForHeadComment:reply]];
        [replyArray addObject:thread];
    }

    return replyArray;
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
