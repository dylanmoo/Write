//
//  Tag.h
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sentence;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSNumber * tag_id;
@property (nonatomic, retain) NSNumber * mentions;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *appears_in;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addAppears_inObject:(Sentence *)value;
- (void)removeAppears_inObject:(Sentence *)value;
- (void)addAppears_in:(NSSet *)values;
- (void)removeAppears_in:(NSSet *)values;

@end
