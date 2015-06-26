//
//  HNAutosizingLabel.m
//  
//
//  Created by Daniel on 6/26/15.
//
//

#import "HNAutosizingLabel.h"

@implementation HNAutosizingLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    if (self.numberOfLines == 0) {
        CGFloat boundsWidth = CGRectGetWidth(bounds);
        if (self.preferredMaxLayoutWidth != boundsWidth) {
            self.preferredMaxLayoutWidth = boundsWidth;
            [self setNeedsUpdateConstraints];
        }
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    
    if (self.numberOfLines == 0) {
        // There's a bug where intrinsic content size may be 1 point too short
        size.height += 1;
    }
    
    return size;

}


@end
