//
//  Sentence.h
//  Write
//
//  Created by Dylan Moore on 10/22/13.
//  Copyright (c) 2013 Dylan Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Sentence : NSManagedObject

@property (nonatomic, retain) NSString * sentence;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * sentence_id;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Sentence (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
