//
//  ViewController.m
//  ObjCCoreDataImportFromFile
//
//  Created by kevin thornton on 10/29/14.
//  Copyright (c) 2014 PCC. All rights reserved.
//

#import "ViewController.h"
#import "Gender.h"
#import "Shoe.h"
#import "ObjectData.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize fetchedGenderResultsController = _fetchedGenderResultsController;
@synthesize fetchedShoeResultsController = _fetchedShoeResultsController;
@synthesize genderType = _genderType;
@synthesize fetchedGenderResultsControllerWithPredicate = _fetchedGenderResultsControllerWithPredicate;



- (void)viewDidLoad {
    [super viewDidLoad];
        // setupFetchedResultsController get a connection to core data(CD)
    [self setupFetchedResultsControllers];
    
    //DELETE all objects from CD - fetched results controllers are reloaded in this method
//    [self deleteFromCD];
    
    // !!!!!  Do we have data in? if not, run importCoreDataObjects to fill CD
    if (![[self.fetchedGenderResultsController fetchedObjects] count] > 0 ) {
        NSLog(@"!!!!! ~~> There's nothing in the database so start import");
        // send up an alert to say "Please wait, loading data"
        
        // Get data into CD
        [self importCoreDataObjects];
        
        // OLD, just grab the first one --> self.genderType = [[self.fetchedGenderResultsController fetchedObjects] objectAtIndex:0];
        // Now that the import is done, iterate over genders showing shoes for each
        for(Gender *forGenderType in [self.fetchedGenderResultsController fetchedObjects]) {
            [self displayShoesForGender:forGenderType];
        }
    } else {
        NSLog(@"Data is in CD so skipping the import");
        // Iterate over genders showing shoes for each
        for(Gender *forGenderType in [self.fetchedGenderResultsController fetchedObjects]) {
            [self displayShoesForGender:forGenderType];
        }
    }
} // VDL

#pragma mark Display - Where it starts
// just log this out for right now --> create buttons in .xib files later
-(void)displayShoesForGender:(Gender *)passedGenderType {
    // !! Remember to put the 'to many' relationhips on Gender > shoe
    NSLog(@"Displaying %@ shoes", passedGenderType.type);
    for (Shoe *shoe in passedGenderType.shoe) {
        NSLog(@"  %@", shoe.name);
    }
}


#pragma mark Import
// get the objects into core data
- (void)importCoreDataObjects{
    [self insertGenderWithGenderName:@"Mens"];
    [self insertGenderWithGenderName:@"Womens"];
}

// insert the objects if nothing found
- (void)insertGenderWithGenderName:(NSString *)genderName {
    NSLog(@"Inserting %@", genderName);
    Gender *gender = [NSEntityDescription insertNewObjectForEntityForName:@"Gender" inManagedObjectContext:self.managedObjectContext];
    gender.type = genderName;
    [self.managedObjectContext save:nil];   //  save
    // performFetch after SAVE so we can refill the fetched results controller
    [self.fetchedGenderResultsController performFetch:nil];

    // now set up a fetched results controller with the prediate genderName to get that one object back from CD and use that to set the relationships
    [self setupGenderFetchedResultsControllersWithPredicate:genderName];
    // set up the MAIN genderType var - be careful using this; should this be local instead?
    self.genderType = [[self.fetchedGenderResultsControllerWithPredicate fetchedObjects] objectAtIndex:0];
    
    // IMPORT
    // I want to do this via a class method but, in ObjectData, I can't seperate out the types easily(XML, JSON, TXT) so I did it with an instance method instead
    //NSArray *shoeArray = [ObjectData createObjectData:genderName];
    // no matter what type of file, genderShoes will be an array of arrays with the subarrays containing the shoe information
    ObjectData *objectData = [[ObjectData alloc] init];
    //  NSArray *genderShoes = [objectData createTextData:genderName];      // from TXT file
    //  NSArray *genderShoes = [objectData createJSONData:genderName];   // from JSON file
    NSArray *genderShoes = [objectData createXMLData:genderName];         // from XML file
    
    for (NSArray *shoeArray in genderShoes) {
        // send array components into the insertShoeWithShoeName method
        [self insertShoeWithShoeName:[shoeArray objectAtIndex:0] genderType:self.genderType shoeType:[shoeArray objectAtIndex:1] price:[shoeArray objectAtIndex:2]];
    }
        
    // yes, do it again for shoes
    [self.managedObjectContext save:nil];
    // refetch to make sure the fetchedShoeResultsController is filled with the latest data
    [self.fetchedShoeResultsController performFetch:nil];
}

// get the shoe data into CD with the relationship to gender
- (void)insertShoeWithShoeName:(NSString *)shoeName genderType:(Gender *)genderType shoeType:(NSString *)shoeType price:(NSString *)price {
    Shoe *shoe = [NSEntityDescription insertNewObjectForEntityForName:@"Shoe" inManagedObjectContext:self.managedObjectContext];
    shoe.name = shoeName;
    shoe.shoetype = shoeType;
    shoe.price = [NSNumber numberWithFloat:[price floatValue]];
    shoe.gender = genderType;
    
}

#pragma mark Deletion
-(void)deleteFromCD {
    //  delete all the genders
    for (Gender *gender in [self.fetchedGenderResultsController fetchedObjects]) {
        NSLog(@"DELETING gender: %@", gender.type);
        [self.managedObjectContext deleteObject:gender];
    }

    //  delete all the shoes
    for (Shoe *shoe in [self.fetchedShoeResultsController fetchedObjects]) {
        NSLog(@"DELETING shoe: %@", shoe.name);
        [self.managedObjectContext deleteObject:shoe];
    }
    // save them out
    [self.managedObjectContext save:nil];
    // reload both fetched controllers
    [self.fetchedGenderResultsController performFetch:nil];
    [self.fetchedShoeResultsController performFetch:nil];
    
}

#pragma mark Set Up
// Set up the fetched Results Controllers
- (void)setupFetchedResultsControllers {
    NSString *entityGender = @"Gender"; // The entity in your model
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityGender);
    NSFetchRequest *requestGender = [NSFetchRequest fetchRequestWithEntityName:entityGender];
    // sort
    requestGender.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"type"
                                                                                  ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    // set up
    self.fetchedGenderResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requestGender
                                                                       managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil cacheName:nil];
    // make sure
    [self.fetchedGenderResultsController performFetch:nil];
    
    // now do the same for the shoe
    NSString *entityShoe = @"Shoe";
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityShoe);
    NSFetchRequest *requestShoe = [NSFetchRequest fetchRequestWithEntityName:entityShoe];
    requestShoe.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                               ascending:YES
                                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedShoeResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:requestShoe
                                                                             managedObjectContext:self.managedObjectContext
                                                                                sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedShoeResultsController performFetch:nil];
}

// Set up the fetched Results Controllers with the predicate of the gender you want returned. this only returns one object
- (void)setupGenderFetchedResultsControllersWithPredicate:(NSString *)thePredicate {
    NSString *entityGender = @"Gender"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller With Predicate for the Entity named %@ and predicate %@", entityGender, thePredicate);
    NSFetchRequest *requestGender = [NSFetchRequest fetchRequestWithEntityName:entityGender];
    requestGender.predicate = [NSPredicate predicateWithFormat:@"type = %@", thePredicate];
    requestGender.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"type"
                                                                                           ascending:YES
                                                                                            selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedGenderResultsControllerWithPredicate = [[NSFetchedResultsController alloc] initWithFetchRequest:requestGender
                                                                              managedObjectContext:self.managedObjectContext
                                                                                sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedGenderResultsControllerWithPredicate performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
