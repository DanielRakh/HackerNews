//
//  HNItem.h
//  
//
//  Created by Daniel on 4/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HNItem : NSManagedObject

@property (nonatomic, retain) NSString * by_;
@property (nonatomic, retain) NSNumber * dead_;
@property (nonatomic, retain) NSNumber * deleted_;
@property (nonatomic, retain) NSNumber * id_;
@property (nonatomic, retain) NSString * text_;
@property (nonatomic, retain) NSNumber * time_;
@property (nonatomic, retain) NSString * type_;
@property (nonatomic, retain) id kids_;

@end
