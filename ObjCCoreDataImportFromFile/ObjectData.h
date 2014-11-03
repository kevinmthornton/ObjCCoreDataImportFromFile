// ObjectData.h - UtilityShoeApp2
//  Copyright (c) 2013 kevin thornton. All rights reserved.
/*
 CLASS: ObjectData
  in the formatting:
 open the file(of any format)
 iterate over values
 create an array of those values
 for (...) {
    NSArray *values = [NSArray arrayWithObjects:shoeName, shoeType, shoePrice, nil];
    add to the 'main' array that will be passed back
    [mainArray addObject:values];
 }
 
 in the AppDeledate file you call:
 NSArray *shoeArrays = [ObjectData returnXMLData:genderName];
 
 for(NSArray *shoeArray in shoeArrays) {
 [self insertShoeWithShoeName:[shoeArray objectAtIndex:0] genderType:self.genderType shoeType:[shoeArray objectAtIndex:1] price:[shoeArray objectAtIndex:2]];
 }
 */

#import <Foundation/Foundation.h>

@interface ObjectData : NSObject
@property (nonatomic, strong) NSMutableArray *objectDataArray;

// create the object data and send back an array
+(NSArray *)createObjectData:(NSString *)genderName;

// all the different types of input
-(NSArray *)createXMLData:(NSString *)genderName;
-(NSArray *)createJSONData:(NSString *)genderName;
-(NSArray *)createTextData:(NSString *)genderName;

@end

 /* Manually add in AppDelegate
 [self insertShoeWithShoeName:@"Mens Runner 1" genderType:self.genderType shoeType:@"Mens Runner" price:@"99.99"];
 [self insertShoeWithShoeName:@"Mens Runner 2" genderType:self.genderType shoeType:@"Mens Runner" price:@"89.99"];
 [self insertShoeWithShoeName:@"Mens Runner 3" genderType:self.genderType shoeType:@"Mens Runner" price:@"79.99"];
 [self insertShoeWithShoeName:@"Mens Boot 1" genderType:self.genderType shoeType:@"Mens Boot" price:@"199.99"];
 [self insertShoeWithShoeName:@"Mens Boot 2" genderType:self.genderType shoeType:@"Mens Boot" price:@"299.99"];
 [self insertShoeWithShoeName:@"Mens Boot 3" genderType:self.genderType shoeType:@"Mens Boot" price:@"399.99"];
 [self insertShoeWithShoeName:@"Mens Sandal 1" genderType:self.genderType shoeType:@"Mens Sandal" price:@"19.99"];
 */

