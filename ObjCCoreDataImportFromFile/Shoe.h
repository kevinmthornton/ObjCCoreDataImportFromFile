//
//  Shoe.h
//  ObjCCoreDataImportFromFile
//
//  Created by kevin thornton on 11/3/14.
//  Copyright (c) 2014 PCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Gender;

@interface Shoe : NSManagedObject

@property (nonatomic, retain) NSString * shoetype;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) Gender *gender;

@end
