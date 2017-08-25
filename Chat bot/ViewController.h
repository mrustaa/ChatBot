//
//  ViewController.h
//  TestChat2
//
//  Created by robert on 02.08.17.
//  Copyright (c) 2017 robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cordinatee.h"
#import "UsersBot.h"



@interface ViewController : UIViewController

@property (strong, nonatomic) UIImage * libraryImage;
@property (strong, nonatomic) NSManagedObjectContext    * managedObjectContext ;
@property (strong, nonatomic) UsersBot * userBot;
- (void)geoPhoto:(UIImage *)image
       cordinate:(Cordinatee *)cordinate  ;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@end
























