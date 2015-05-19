//
//  UIView+FindUITableView.m
//  HackerNews
//
//  Created by Daniel on 5/18/15.
//  Copyright (c) 2015 Daniel Rakhamimov. All rights reserved.
//

#import "UIView+FindUITableView.h"

@implementation UIView (FindUITableView)


-(UITableView *) parentTableView {
    // iterate up the view hierarchy to find the table containing this cell/view
    UIView *aView = self.superview;
    while(aView != nil) {
        if([aView isKindOfClass:[UITableView class]]) {
            return (UITableView *)aView;
        }
        aView = aView.superview;
    }
    return nil; // this view is not within a tableView
}



@end