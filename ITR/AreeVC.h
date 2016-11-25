//
//  AreeVC.h
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModule.h"

@interface AreeVC : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DataModule *db;
@property (strong, nonatomic) NSDictionary *societaDict;
@property (strong, nonatomic) NSString *societaSel;
@property (strong, nonatomic) NSDictionary *areeDict;

@end
