//
//  DataModule.h
//  Magazzino
//
//  Created by if65 on 21/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModule : NSObject

-(id) init;
-(void) createDB;
-(void) resetDB;

-(NSDictionary *) getListPeriodi;
-(NSDictionary *) getListSocieta;
-(NSDictionary *) getListAreeWithSocieta:(NSString *)societa;
-(NSDictionary *) getListSediWithArea:(NSString *)area andSocieta:(NSString *) societa andInsegna:(NSString *)insegna;

-(bool) updateSortAreeWithSocieta:(NSString *)societa andListAree:(NSArray *)aree;

-(bool) insertRecordInTableSocietaWithArrayOfSocieta:(NSArray *)societa;
-(bool) insertRecordInTableAreeWithArrayOfAree:(NSArray *)aree andArrayOfLink:(NSArray *)link;
-(bool) insertRecordInTableSediWithArrayOfSedi:(NSArray *)sedi;

@end
