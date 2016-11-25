//
//  SetupSocietaVC.m
//  ITR
//
//  Created by if65 on 25/09/2016.
//  Copyright © 2016 if65. All rights reserved.
//

#import "SetupSocietaVC.h"
#import "DataModule.h"

@interface SetupSocietaVC ()

    @property (strong, nonatomic) DataModule *db;
    @property (strong, nonatomic) NSDictionary *societaDict;

@end

@implementation SetupSocietaVC {
    NSMutableArray *societa;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    _db =[DataModule new];
    _societaDict = [_db getListSocieta];
    
    societa = [[NSMutableArray alloc]initWithArray:[[_societaDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    return societa.count + ([tableView isEditing] ? 1 : 0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetupSocietaCell" forIndexPath:indexPath];
    
    if (indexPath.row > societa.count && [tableView isEditing]) {
        cell.textLabel.text = @"Aggiungi Società";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;
    } else {
        
        NSString *descrizioneSocieta = [[NSString alloc] initWithFormat:@"%@ - %@",_societaDict[societa[indexPath.row]][@"codice"],_societaDict[societa[indexPath.row]][@"descrizione"]];
        
        cell.textLabel.text = descrizioneSocieta;
        cell.detailTextLabel.text = _societaDict[societa[indexPath.row]][@"ip"];
    }
    return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        [societa removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
