//
//  AreeVC.m
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "AreeVC.h"
#import "PeriodiVC.h"

@interface AreeVC ()

@end

@implementation AreeVC {
    NSMutableArray *aree;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Modifica";
    self.tabBarController.tabBar.hidden = YES;
    
    _areeDict = [_db getListAreeWithSocieta:_societaSel];
    
    //aree = [[_areeDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordinamento" ascending:YES selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    aree = [NSMutableArray arrayWithArray:[[[_areeDict allValues] sortedArrayUsingDescriptors:descriptors] valueForKey:@"codice"]];
    
    //NSLog(@"%@", aree);
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
    
    return [aree count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCell" forIndexPath:indexPath];
    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    cell.textLabel.text = _areeDict[aree[indexPath.row]][@"descrizione"];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"Sedi: %@", _areeDict[aree[indexPath.row]][@"numero_sedi"]];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.editButtonItem.title = NSLocalizedString(@"Fatto", @"Fatto");
    }
    else
    {
        self.editButtonItem.title = NSLocalizedString(@"Modifica", @"Modifica");
    }
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


#pragma mark - Move rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section != toIndexPath.section || (fromIndexPath.section == toIndexPath.section && fromIndexPath.row != toIndexPath.row)) {
        /*long areaToMove = [[aree objectAtIndex:fromIndexPath.row] longValue];
        NSLog(@"%@",aree);*/
        
        if (fromIndexPath.row > toIndexPath.row) {
            for (long i=fromIndexPath.row; i > toIndexPath.row;i--) {
                [aree exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                NSLog(@"%@",aree);
            }
        } else {
            for (long i=fromIndexPath.row; i < toIndexPath.row;i++) {
                [aree exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                NSLog(@"%@",aree);
            }
        }
        
        [_db updateSortAreeWithSocieta:_societaSel andListAree:aree];
        NSLog(@"%@", aree);
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toProposedIndexPath:(nonnull NSIndexPath *)proposedDestinationIndexPath {

    if (proposedDestinationIndexPath.section == 0 && proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Aree" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    PeriodiVC *nextView = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    nextView.db = _db;
    nextView.societaDict = _societaDict;
    nextView.societaSel = _societaSel;
    nextView.areeDict = _areeDict;
    nextView.areaSel = aree[indexPath.row];
}


@end
