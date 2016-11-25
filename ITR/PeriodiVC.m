//
//  PeriodiVC.m
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "PeriodiVC.h"
#import "SediVC.h"

@interface PeriodiVC ()

@end

@implementation PeriodiVC {
    NSArray *periodi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       _periodiDict = [_db getListPeriodi];
    
    //periodi = [[_periodiDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"posizione" ascending:YES selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    periodi = [[[_periodiDict allValues] sortedArrayUsingDescriptors:descriptors] valueForKey:@"descrizione"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return periodi.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeriodoCell" forIndexPath:indexPath];
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cell.textLabel.text = periodi[indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Periodi" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    SediVC *nextView = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    nextView.db = _db;
    nextView.societaDict = _societaDict;
    nextView.societaSel = _societaSel;
    nextView.areeDict = _areeDict;
    nextView.areaSel = _areaSel;
    nextView.periodiDict = _periodiDict;
    nextView.periodoSel = periodi[indexPath.row];
}


@end
