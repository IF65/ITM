//
//  SediC.h
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SediC : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *codiceSede;
@property (strong, nonatomic) IBOutlet UILabel *descrizioneSede;
@property (strong, nonatomic) IBOutlet UILabel *totaleOdierno;
@property (strong, nonatomic) IBOutlet UILabel *delta;
@property (strong, nonatomic) IBOutlet UILabel *deltaP;
@property (strong, nonatomic) IBOutlet UILabel *descrizionePeriodo;

@end
