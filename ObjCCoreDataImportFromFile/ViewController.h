//
//  ViewController.h
//  ObjCCoreDataImportFromFile
//
//  Created by kevin thornton on 10/29/14.
//  Copyright (c) 2014 PCC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Gender, Shoe, ObjectData;

@interface ViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// two, one for gender and one for shoe for that gender
@property (strong, nonatomic) NSFetchedResultsController *fetchedGenderResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedShoeResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedGenderResultsControllerWithPredicate;

// to hold the genderType
@property(strong, nonatomic) Gender *genderType;

// display the shoes for a passed gender
- (void)displayShoesForGender:(Gender *)genderType;

// get the objects into core data
- (void)importCoreDataObjects;
// insert specific entity objects
- (void)insertGenderWithGenderName:(NSString *)genderName;
- (void)insertShoeWithShoeName:(NSString *)shoeName genderType:(Gender *)genderType shoeType:(NSString *)shoeType price:(NSString *)price;

//  delete everything from CD
-(void) deleteFromCD;
// set up BOTH the Gender and Shoe fetchedResultsControllers
- (void)setupFetchedResultsControllers;


@end

