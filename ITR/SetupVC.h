//
//  SetupVC.h
//  ITR
//
//  Created by if65 on 25/09/2016.
//  Copyright © 2016 if65. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SOAPEngine64/SOAPEngine.h>
#import "DataModule.h"

@interface SetupVC : UITableViewController <SOAPEngineDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)aggiornamentoAutomatico:(id)sender;


@end
