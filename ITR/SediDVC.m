//
//  SediDVC.m
//  ITR
//
//  Created by if65 on 05/09/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "SediDVC.h"
#import "SediDC.h"

@interface SediDVC ()

@end

@implementation SediDVC {
    NSArray *selettori;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SediDC *cell = [tableView dequeueReusableCellWithIdentifier:@"CellSediD" forIndexPath:indexPath];
    
    NSString *minusSign = @"-";
    
    UIColor *darkGreen = [[UIColor alloc ] initWithRed:34/255.0 green:139/255.0 blue:34/255.0 alpha:1.0];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

    
    
    [formatter setGroupingSize:3];
    [formatter setGroupingSeparator:@"."];
    [formatter setCurrencySymbol:@""];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setMaximumFractionDigits:0];
    [formatter setMinimumFractionDigits:0];
    [formatter setMinusSign:minusSign];
    [formatter setDecimalSeparator:@","];
    
    if (indexPath.row == 0) {
        cell.selettore.text = @"Totale Odierno";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotaleOdierno = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_ODIERNO"]] floatValue];
        float varTotaleOdiernoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_ODIERNO_AP"]] floatValue];
        float varDelta = varTotaleOdierno - varTotaleOdiernoAP;
        float varDeltaP = varTotaleOdiernoAP ? varDelta/varTotaleOdiernoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotaleOdierno]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
    } else if (indexPath.row == 1) {
        cell.selettore.text = @"Scontrini";
        cell.selettoreDelta.text = @"Passaggi";
        cell.selettoreDeltaP.text = @"Conversione %";
        
        float varTotaleScontriniOdierni = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_ODIERNI"]] floatValue];
        float varTotalePassaggiOdierni = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PASSAGGI_ODIERNI"]] floatValue];
        float varFattoreConversioneP = varTotalePassaggiOdierni ? varTotaleScontriniOdierni/varTotalePassaggiOdierni : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotaleScontriniOdierni]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotalePassaggiOdierni]];
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varFattoreConversioneP]]];

        
    } else if (indexPath.row == 2) {
        cell.selettore.text = @"Acquisto Medio";
        cell.selettoreDelta.text = @"Ultimo Scontrino";
        cell.selettoreDeltaP.text = @"";
        
        float varTotaleOdierno = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_ODIERNO"]] floatValue];
        float varTotaleScontriniOdierni = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_ODIERNI"]] floatValue];
        float varScontrinoMedio = varTotaleScontriniOdierni ? varTotaleOdierno/varTotaleScontriniOdierni : 0;
        
        NSString *varOraUltimoScontrino = @"*";
        if ([_totale[@"ORA_ULTIMO_SCONTRINO"] isKindOfClass:[NSString class]]) {
            varOraUltimoScontrino = [[[NSString alloc] initWithString:_totale[@"ORA_ULTIMO_SCONTRINO"]] substringToIndex:8];
        }
        
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varScontrinoMedio]];;
        cell.delta.text = varOraUltimoScontrino;
        
        [cell.deltap setHidden:YES];
    } else if (indexPath.row == 3) {
        cell.selettore.text = @"Totale Periodo";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotalePeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO"]] floatValue];
        float varTotalePeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO_AP"]] floatValue];
        float varDelta = varTotalePeriodo - varTotalePeriodoAP;
        float varDeltaP = varTotalePeriodoAP ? varDelta/varTotalePeriodoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotalePeriodo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    } else if (indexPath.row == 4) {
        cell.selettore.text = @"Totale Periodo Obb.";
        cell.selettoreDelta.text = @"Delta";
        cell.selettoreDeltaP.text = @"";
        
        float varTotalePeriodoObbiettivo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO_OBBIETTIVO_AP"]] floatValue];
        float varTotalePeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO"]] floatValue];
        float varDelta = varTotalePeriodo - varTotalePeriodoObbiettivo;
        float varDeltaP = varTotalePeriodo ? varDelta/varTotalePeriodo : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotalePeriodoObbiettivo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    } else if (indexPath.row == 5) {
        cell.selettore.text = @"Clienti Periodo";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotaleScontriniPeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_PERIODO"]] floatValue];
        float varTotaleScontriniPeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_PERIODO_AP"]] floatValue];
        float varDelta = varTotaleScontriniPeriodo - varTotaleScontriniPeriodoAP;
        float varDeltaP = varTotaleScontriniPeriodoAP ? varDelta/varTotaleScontriniPeriodoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotaleScontriniPeriodo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    }  else if (indexPath.row == 6) {
        cell.selettore.text = @"Ore Periodo";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotaleOrePeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_ORE_LAVORATE_PERIODO"]] floatValue];
        float varTotaleOrePeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_ORE_LAVORATE_PERIODO_AP"]] floatValue];
        float varDelta = varTotaleOrePeriodo - varTotaleOrePeriodoAP;
        float varDeltaP = varTotaleOrePeriodoAP ? varDelta/varTotaleOrePeriodoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        [formatter setMinimumFractionDigits:1];
        [formatter setMultiplier:@1];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotaleOrePeriodo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    } else if (indexPath.row == 7) {
        cell.selettore.text = @"Passaggi Periodo";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotalePassaggiPeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PASSAGGI"]] floatValue];
        float varTotalePassaggiPeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PASSAGGI_AP"]] floatValue];
        float varDelta = varTotalePassaggiPeriodo - varTotalePassaggiPeriodoAP;
        float varDeltaP = varTotalePassaggiPeriodoAP ? varDelta/varTotalePassaggiPeriodoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        [formatter setMaximumFractionDigits:0];
        [formatter setMinimumFractionDigits:0];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotalePassaggiPeriodo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    } else if (indexPath.row == 8) {
        cell.selettore.text = @"Acq. Medio Periodo";
        cell.selettoreDelta.text = @"Delta su A.P.";
        cell.selettoreDeltaP.text = @"";
        
        float varTotaleScontriniPeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_PERIODO"]] floatValue];
        float varTotaleScontriniPeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_SCONTRINI_PERIODO_AP"]] floatValue];
        float varTotalePeriodo = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO"]] floatValue];
        float varTotalePeriodoAP = [[[NSString alloc]initWithFormat:@"%@",_totale[@"TOTALE_PERIODO_AP"]] floatValue];
        
        float varAcquistoMedioPeriodo = varTotaleScontriniPeriodo ? varTotalePeriodo/varTotaleScontriniPeriodo : 0;
        float varAcquistoMedioPeriodoAP = varTotaleScontriniPeriodoAP ? varTotalePeriodoAP/varTotaleScontriniPeriodoAP : 0;
        
        float varDelta = varAcquistoMedioPeriodo - varAcquistoMedioPeriodoAP;
        float varDeltaP = varAcquistoMedioPeriodoAP ? varDelta/varAcquistoMedioPeriodoAP : 0;
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMultiplier:@1];
        cell.attuale.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varAcquistoMedioPeriodo]];
        cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
        cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
        
        [formatter setNumberStyle:NSNumberFormatterPercentStyle];
        [formatter setMultiplier:@100];
        [formatter setMaximumFractionDigits:2];
        [formatter setMinimumFractionDigits:2];
        cell.deltap.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
        cell.deltap.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    }

    
    
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
