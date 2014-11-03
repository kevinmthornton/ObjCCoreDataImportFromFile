//
//  ObjectData.m
//  UtilityShoeApp2
//
//  Created by kevin thornton on 1/11/13.
//  Copyright (c) 2013 kevin thornton. All rights reserved.
//

#import "ObjectData.h"

@implementation ObjectData
@synthesize objectDataArray;



#pragma mark XML Data

-(NSArray *)createXMLData:(NSString *)genderName{
    objectDataArray = [[NSMutableArray alloc] init];    // start the return array
    // grab this file out of the resources folder
    NSURL *genderUrl = [[NSBundle mainBundle] URLForResource:genderName withExtension:@"xml"];
    // set up the dictionary
    NSArray *genderShoes = [[NSArray alloc ] initWithContentsOfURL:genderUrl];
//    NSLog(@"genderShoes: %@", genderShoes);
    for(NSArray *shoeLine in genderShoes) {
        // order them according to: name, type, price
        NSArray *shoeArray = [[NSMutableArray alloc] initWithObjects:[shoeLine objectAtIndex:0], [shoeLine objectAtIndex:1], [shoeLine objectAtIndex:2], nil];
        // add array to the main array
        [objectDataArray addObject:shoeArray];
    }
    
    return objectDataArray;
}

#pragma mark JSON Data

-(NSArray *)createJSONData:(NSString *)genderName{
    objectDataArray = [[NSMutableArray alloc] init];    // start the return array
    // get the file
    NSString *genderPathName = [[NSBundle mainBundle] pathForResource:genderName ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:genderPathName];
    NSError *error=nil;
    // JSON will return us a dictionary of shoeList = (Arrays)
    NSDictionary *shoeListDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    // genderShoes becomes an array of arrays
    NSArray *genderShoes = [[NSArray alloc] initWithArray:[shoeListDictionary valueForKey:@"shoeList"]];
    for(NSArray *shoeLine in genderShoes) {
        // order them according to: name, type, price
        NSArray *shoeArray = [[NSMutableArray alloc] initWithObjects:[shoeLine valueForKey:@"shoeName"], [shoeLine valueForKey:@"shoeType"], [shoeLine valueForKey:@"price"], nil];
        // add array to the main array
        [objectDataArray addObject:shoeArray];
    }
    
    return objectDataArray;
}


#pragma mark Text Data
-(NSArray *)createTextData:(NSString *)genderName{
    objectDataArray = [[NSMutableArray alloc] init];
    // open the passed "genderName".txt file and iterate over it - passing gender.type to insertShoeWithShoeName
    NSString *genderPathName = [[NSBundle mainBundle] pathForResource:genderName ofType:@"txt"];
    NSArray *genderShoes = [[NSString stringWithContentsOfFile:genderPathName encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    for (NSString *shoeLine in genderShoes) {
        // seperate out string
        NSArray *shoeComponents = [shoeLine componentsSeparatedByString:@"#"];
        // fill up shoe array with values from file according to: name, type, price
        NSArray *shoeArray = [[NSMutableArray alloc] initWithObjects:[shoeComponents objectAtIndex:0], [shoeComponents objectAtIndex:1], [shoeComponents objectAtIndex:2], nil];
        // add array to the main array
        [objectDataArray addObject:shoeArray];
    }
    
     return objectDataArray;
}


// input the object data and send back an array
// pass in genderName to grab which file we should be opening
// I want to use this class method but, you can't use any outside help; everything must be done inside this one method
// if I knew the type, I could do it this way but, with the instance methods, this is more flexible
+(NSArray *)createObjectData:(NSString *)genderName {
    NSArray *dataArray = nil; //createTextData:genderName;
    
    return dataArray;
    
}
@end
