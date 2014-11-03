//
//  Gender.h
//  ObjCCoreDataImportFromFile
//
//  Created by kevin thornton on 11/3/14.
//  Copyright (c) 2014 PCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Shoe;

@interface Gender : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *shoe;
@end

@interface Gender (CoreDataGeneratedAccessors)

- (void)addShoeObject:(Shoe *)value;
- (void)removeShoeObject:(Shoe *)value;
- (void)addShoe:(NSSet *)values;
- (void)removeShoe:(NSSet *)values;

@end
