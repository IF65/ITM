//
//  InsegneVC.m
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "SocietaVC.h"
#import "AreeVC.h"
#import "SocietaC.h"

@interface SocietaVC ()

@property (strong, nonatomic) DataModule *db;
@property (strong, nonatomic) NSDictionary *societaDict;

@end

@implementation SocietaVC {
    NSArray *societa;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    _db = [[DataModule alloc]init];
    
    
    
    
    //NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    //NSLog(@"%@", docDirPath);
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
    
    return [societa count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SocietaC *cell = [tableView dequeueReusableCellWithIdentifier:@"SocietaCell" forIndexPath:indexPath];
    
    /*cell.imageView.image = [UIImage imageNamed:@"logo_supermedia.gif"];
    cell.textLabel.text = _societaDict[societa[indexPath.row]][@"descrizione"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Sedi: %@", _societaDict[societa[indexPath.row]][@"numero_sedi"]];*/
    
    NSString *codice_societa = _societaDict[societa[indexPath.row]][@"codice"];
    
    NSString *logo = @"";
    if ([codice_societa  isEqual: @"01"]) {
        logo = @"italmark.jpg";
    } else if ([codice_societa  isEqual: @"07"]) {
        logo = @"sportland.jpg";
    } else if ([codice_societa  isEqual: @"08"]) {
        logo = @"supermedia.jpg";
    } else if ([codice_societa  isEqual: @"10"]) {
        logo = @"ecobrico.jpg";
    } else if ([codice_societa  isEqual: @"53"]) {
        logo = @"res.jpg";
    } else if ([codice_societa  isEqual: @"19"]) {
        logo = @"goassist.jpg";
    }
    
    cell.immagine.image = [UIImage imageNamed:logo];
    cell.titolo.text = _societaDict[societa[indexPath.row]][@"descrizione"];
    cell.sottotitolo.text = [NSString stringWithFormat:@"Sedi: %@", _societaDict[societa[indexPath.row]][@"numero_sedi"]];
    
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Società" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    AreeVC *nextView = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    nextView.db = _db;
    nextView.societaDict = _societaDict;
    nextView.societaSel = societa[indexPath.row];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;
    
    _societaDict = [_db getListSocieta];
    societa = [[_societaDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView reloadData];
}

@end
