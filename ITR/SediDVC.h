//
//  SediDVC.h
//  ITR
//
//  Created by if65 on 05/09/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModule.h"

@interface SediDVC : UITableViewController

@property (strong, nonatomic) DataModule *db;
@property (strong, nonatomic) NSDictionary *societaDict;
@property (strong, nonatomic) NSString *societaSel;
@property (strong, nonatomic) NSDictionary *areeDict;
@property (strong, nonatomic) NSString *areaSel;
@property (strong, nonatomic) NSDictionary *periodiDict;
@property (strong, nonatomic) NSString *periodoSel;
@property (strong, nonatomic) NSDictionary *sediDict;
@property (strong, nonatomic) NSString *sedeSel;
@property (strong, nonatomic) NSMutableDictionary *totale;

@end
