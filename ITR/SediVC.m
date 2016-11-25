//
//  SediVC.m
//  ITR
//
//  Created by if65 on 31/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "SediVC.h"
#import "SediC.h"
#import "SediDVC.h"

@interface SediVC ()

@end

@implementation SediVC {
    SOAPEngine *soap;
    
    NSMutableDictionary *totali;
    NSArray *sedi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _sediDict = [_db getListSediWithArea:_areaSel andSocieta:_societaSel andInsegna:@""];
    
    /*NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ordinamento" ascending:YES selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    sedi = [[[_sediDict allValues] sortedArrayUsingDescriptors:descriptors] valueForKey:@"codice"];*/
    
    /*sedi = [[_sediDict allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = [(NSString *)obj1[@"codice"] substringFromIndex:2];
        NSString * str2 = [(NSString *)obj2[@"codice"] substringFromIndex:2];
        return [str1 compare:str2 options:NSNumericSearch];
    }];*/
    
    sedi = [[_sediDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * str1 = [(NSString *)obj1 substringFromIndex:0];
        NSString * str2 = [(NSString *)obj2 substringFromIndex:0];
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    
    self.navigationItem.leftBarButtonItem.title = @"Periodi";
    
    totali = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSString *sede in sedi) {
        [totali setObject:@{@"CODICE_SEDE":sede,
                            @"TOTALE_ODIERNO":@0,
                            @"TOTALE_PERIODO":@0,
                            @"TOTALE_MARGINE_PERIODO":@0,
                            @"TOTALE_MARGINE_ODIERNO":@0,
                            @"TOTALE_VENDUTO_IN_PROMO_PERIODO":@0,
                            @"TOTALE_VENDUTO_IN_PROMO_ODIERNO":@0,
                            @"TOTALE_SCONTRINI_ODIERNI":@0,
                            @"TOTALE_SCONTRINI_PERIODO":@0,
                            @"TIPO_APERTURA":@"",
                            @"TOTALE_ORE_LAVORATE":@0,
                            @"TOTALE_ORE_LAVORATE_PERIODO":@0,
                            @"TOTALE_ODIERNO_AP":@0,
                            @"TOTALE_PERIODO_AP":@0,
                            @"TOTALE_MARGINE_PERIODO_AP":@0,
                            @"TOTALE_MARGINE_ODIERNO_AP":@0,
                            @"TOTALE_VENDUTO_IN_PROMO_PERIODO_AP":@0,
                            @"TOTALE_VENDUTO_IN_PROMO_ODIERNO_AP":@0,
                            @"TOTALE_SCONTRINI_PERIODO_AP":@0,
                            @"TOTALE_ORE_LAVORATE_PERIODO_AP":@0,
                            @"ORA_ULTIMO_SCONTRINO":@0,
                            @"TOTALE_PERIODO_OBBIETTIVO_AP":@0,
                            @"TOTALE_PASSAGGI":@0,
                            @"TOTALE_PASSAGGI_ODIERNI":@0,
                            @"TOTALE_PASSAGGI_AP":@0,
                            @"SONO_LA_DIREZIONE":@0,
                            @"GIORNI_DI_APERTURA":@0
                            } forKey:sede];
    }
    
    [totali setObject:@{@"CODICE_SEDE":@"TOTALE",
                        @"TOTALE_ODIERNO":@0,
                        @"TOTALE_PERIODO":@0,
                        @"TOTALE_MARGINE_PERIODO":@0,
                        @"TOTALE_MARGINE_ODIERNO":@0,
                        @"TOTALE_VENDUTO_IN_PROMO_PERIODO":@0,
                        @"TOTALE_VENDUTO_IN_PROMO_ODIERNO":@0,
                        @"TOTALE_SCONTRINI_ODIERNI":@0,
                        @"TOTALE_SCONTRINI_PERIODO":@0,
                        @"TIPO_APERTURA":@"",
                        @"TOTALE_ORE_LAVORATE":@0,
                        @"TOTALE_ORE_LAVORATE_PERIODO":@0,
                        @"TOTALE_ODIERNO_AP":@0,
                        @"TOTALE_PERIODO_AP":@0,
                        @"TOTALE_MARGINE_PERIODO_AP":@0,
                        @"TOTALE_MARGINE_ODIERNO_AP":@0,
                        @"TOTALE_VENDUTO_IN_PROMO_PERIODO_AP":@0,
                        @"TOTALE_VENDUTO_IN_PROMO_ODIERNO_AP":@0,
                        @"TOTALE_SCONTRINI_PERIODO_AP":@0,
                        @"TOTALE_ORE_LAVORATE_PERIODO_AP":@0,
                        @"ORA_ULTIMO_SCONTRINO":@0,
                        @"TOTALE_PERIODO_OBBIETTIVO_AP":@0,
                        @"TOTALE_PASSAGGI":@0,
                        @"TOTALE_PASSAGGI_ODIERNI":@0,
                        @"TOTALE_PASSAGGI_AP":@0,
                        @"SONO_LA_DIREZIONE":@0,
                        @"GIORNI_DI_APERTURA":@0
                        } forKey:@"TOTALE"];

    for (NSString *sede in sedi) {
        [self recuperaIncassoByProxy:sede];
    }
    
  
}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.bottomToolbar.frame;
    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.bottomToolbar.frame.size.height;
    self.bottomToolbar.frame = frame;
    
    [self.view bringSubviewToFront:self.bottomToolbar];
}*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SOAPEngine Delegates

- (void)soapEngine:(SOAPEngine *)soapEngine didFinishLoading:(NSString *)stringXML dictionary:(NSDictionary *)dict {
    
    // recupero il dictionary originale del negozio e copi la parte significativa nel resultDict
    NSDictionary *resultDict = [[NSDictionary alloc] initWithDictionary:dict[@"Body"][@"ssIncassiProxyCallResponse"]];
    
    // ora creo tempDict che userò per aggiornare il valore di totali (dictionary)
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:totali[[soapEngine.soapNamespace substringFromIndex:2]]];

    tempDict[@"CODICE_SEDE"] = resultDict[@"CODICE_SEDE"][@"value"];
    tempDict[@"TOTALE_ODIERNO"] = resultDict[@"TOTALE_ODIERNO"][@"value"];
    tempDict[@"TOTALE_PERIODO"] = resultDict[@"TOTALE_PERIODO"][@"value"];
    tempDict[@"TOTALE_MARGINE_PERIODO"] = resultDict[@"TOTALE_MARGINE_PERIODO"][@"value"];
    tempDict[@"TOTALE_MARGINE_ODIERNO"] = resultDict[@"TOTALE_MARGINE_ODIERNO"][@"value"];
    tempDict[@"TOTALE_VENDUTO_IN_PROMO_PERIODO"] = resultDict[@"TOTALE_VENDUTO_IN_PROMO_PERIODO"][@"value"];
    tempDict[@"TOTALE_VENDUTO_IN_PROMO_ODIERNO"] = resultDict[@"TOTALE_VENDUTO_IN_PROMO_ODIERNO"][@"value"];
    tempDict[@"TOTALE_SCONTRINI_ODIERNI"] = resultDict[@"TOTALE_SCONTRINI_ODIERNI"][@"value"];
    tempDict[@"TOTALE_SCONTRINI_PERIODO"] = resultDict[@"TOTALE_SCONTRINI_PERIODO"][@"value"];
    tempDict[@"TIPO_APERTURA"] = resultDict[@"TIPO_APERTURA"][@"value"];
    tempDict[@"TOTALE_ORE_LAVORATE"] = resultDict[@"TOTALE_ORE_LAVORATE"][@"value"];
    tempDict[@"TOTALE_ORE_LAVORATE_PERIODO"] = resultDict[@"TOTALE_ORE_LAVORATE_PERIODO"][@"value"];
    tempDict[@"TOTALE_ODIERNO_AP"] = resultDict[@"TOTALE_ODIERNO_AP"][@"value"];
    tempDict[@"TOTALE_PERIODO_AP"] = resultDict[@"TOTALE_PERIODO_AP"][@"value"];
    tempDict[@"TOTALE_MARGINE_PERIODO_AP"] = resultDict[@"TOTALE_MARGINE_PERIODO_AP"][@"value"];
    tempDict[@"TOTALE_MARGINE_ODIERNO_AP"] = resultDict[@"TOTALE_MARGINE_ODIERNO_AP"][@"value"];
    tempDict[@"TOTALE_VENDUTO_IN_PROMO_PERIODO_AP"] = resultDict[@"TOTALE_VENDUTO_IN_PROMO_PERIODO_AP"][@"value"];
    tempDict[@"TOTALE_VENDUTO_IN_PROMO_ODIERNO_AP"] = resultDict[@"TOTALE_VENDUTO_IN_PROMO_ODIERNO_AP"][@"value"];
    tempDict[@"TOTALE_SCONTRINI_PERIODO_AP"] = resultDict[@"TOTALE_SCONTRINI_PERIODO_AP"][@"value"];
    tempDict[@"TOTALE_ORE_LAVORATE_PERIODO_AP"] = resultDict[@"TOTALE_ORE_LAVORATE_PERIODO_AP"][@"value"];
    tempDict[@"ORA_ULTIMO_SCONTRINO"] = resultDict[@"ORA_ULTIMO_SCONTRINO"][@"value"];
    tempDict[@"TOTALE_PERIODO_OBBIETTIVO_AP"] = resultDict[@"TOTALE_PERIODO_OBBIETTIVO_AP"][@"value"];
    tempDict[@"TOTALE_PASSAGGI"] = resultDict[@"TOTALE_PASSAGGI"][@"value"];
    tempDict[@"TOTALE_PASSAGGI_ODIERNI"] = resultDict[@"TOTALE_PASSAGGI_ODIERNI"][@"value"];
    tempDict[@"TOTALE_PASSAGGI_AP"] = resultDict[@"TOTALE_PASSAGGI_AP"][@"value"];
    tempDict[@"SONO_LA_DIREZIONE"] = resultDict[@"SONO_LA_DIREZIONE"][@"value"];
    tempDict[@"GIORNI_DI_APERTURA"] = resultDict[@"GIORNI_DI_APERTURA"][@"value"];
    
    // e sostituisco il dictionary originale con quello modificato
    totali[tempDict[@"CODICE_SEDE"]] = tempDict;
    
    [self ricalcoloTotale];
    
    [self.tableView reloadData];
    
}

- (BOOL)soapEngine:(SOAPEngine *)soapEngine didReceiveResponseCode:(NSInteger)statusCode {
    
    // 200 is response Ok, 500 Server error
    // see http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
    // for more response codes
    if (statusCode != 200 && statusCode != 500) {
        NSString *msg = [NSString stringWithFormat:@"ERROR: received status code %li", (long)statusCode];
        NSLog(@"%@",msg);
        
        return NO;
    }
    
    return YES;
}

- (NSMutableURLRequest*)soapEngine:(SOAPEngine *)soapEngine didBeforeSendingURLRequest:(NSMutableURLRequest *)request {
    
    // use this delegate for personalize the header of the request
    // eg: [request setValue:@"my-value" forHTTPHeaderField:@"my-header-field"];
    
    //NSLog(@"%@", [request allHTTPHeaderFields]);
    
    //NSString *xml = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", xml);
    
    return request;
}

- (NSString *)soapEngine:(SOAPEngine *)soapEngine didBeforeParsingResponseString:(NSString *)stringXML
{
    // use this delegate for change the xml response before parsing it.
    
    // NSLog(@"%@",stringXML);
    
    return stringXML;
}

- (void)soapEngine:(SOAPEngine *)soapEngine didReceiveDataSize:(NSUInteger)current total:(NSUInteger)total
{
    //NSLog(@"Received %lu bytes of %lu bytes", (unsigned long)current, (unsigned long)total);
}

- (void)soapEngine:(SOAPEngine *)soapEngine didSendDataSize:(NSUInteger)current total:(NSUInteger)total
{
    //NSLog(@"Sended %lu bytes of %lu bytes", (unsigned long)current, (unsigned long)total);
}

- (void)soapEngine:(SOAPEngine *)soapEngine didFailWithError:(NSError *)error {
    
    NSString *msg = [NSString stringWithFormat:@"ERROR: %@", error.localizedDescription];
    NSLog(@"%@", msg);
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ! section ? 1 : sedi.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //_areeDict[_areaSel][@"descrizione"], _periodoSel
        return @"Area";
    } else {
        return @"Negozi";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SediC *cell = [tableView dequeueReusableCellWithIdentifier:@"SediCell" forIndexPath:indexPath];
    
    float varTotaleOdierno;
    float varTotalePeriodo;
    float varTotalePeriodoAP;
    float varDelta;
    float varDeltaP;
    if (! indexPath.section) {
        varTotaleOdierno = [[[NSString alloc]initWithFormat:@"%@",totali[@"TOTALE"][@"TOTALE_ODIERNO"]] floatValue];
        varTotalePeriodo = [[[NSString alloc]initWithFormat:@"%@",totali[@"TOTALE"][@"TOTALE_PERIODO"]] floatValue];
        varTotalePeriodoAP = [[[NSString alloc]initWithFormat:@"%@",totali[@"TOTALE"][@"TOTALE_PERIODO_AP"]] floatValue];
        varDelta = varTotalePeriodo - varTotalePeriodoAP;
        varDeltaP = varTotalePeriodoAP ? varDelta/varTotalePeriodoAP : 0;
        
        /*NSString *dC = _periodiDict[_periodoSel][@"data_corrente"];
        NSString *dI = _periodiDict[_periodoSel][@"data_inizio"];
        NSString *dF = _periodiDict[_periodoSel][@"data_fine"];
        NSString *dCAP = _periodiDict[_periodoSel][@"data_corrente_ap"];
        NSString *dIAP = _periodiDict[_periodoSel][@"data_inizio_ap"];
        NSString *dFAP = _periodiDict[_periodoSel][@"data_fine_ap"];

        NSString *descrizionePeriodo = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@, %@, %@", dC, dI, dF, dCAP, dIAP, dFAP];*/
        
        NSString *descrizionePeriodo = _periodoSel;
        
        cell.codiceSede.text = @"Totale";
        cell.descrizioneSede.text = [[[NSString alloc] initWithFormat: @"Area: %@", _areeDict[_areaSel][@"descrizione"]] capitalizedString];
        cell.descrizionePeriodo.text = [[NSString alloc] initWithFormat: @"Periodo: %@",descrizionePeriodo];
    } else {
    
        varTotaleOdierno = [[[NSString alloc]initWithFormat:@"%@",totali[sedi[indexPath.row]][@"TOTALE_ODIERNO"]] floatValue];
        varTotalePeriodo = [[[NSString alloc]initWithFormat:@"%@",totali[sedi[indexPath.row]][@"TOTALE_PERIODO"]] floatValue];
        varTotalePeriodoAP = [[[NSString alloc]initWithFormat:@"%@",totali[sedi[indexPath.row]][@"TOTALE_PERIODO_AP"]] floatValue];
        varDelta = varTotalePeriodo - varTotalePeriodoAP;
        varDeltaP = varTotalePeriodoAP ? varDelta/varTotalePeriodoAP : 0;
        
        // etichette a sx
        cell.codiceSede.text = _sediDict[sedi[indexPath.row]][@"codice"];
        cell.descrizioneSede.text = [_sediDict[sedi[indexPath.row]][@"descrizione"] capitalizedString];
        cell.descrizionePeriodo.text = @"";

    }
    
    UIColor *darkGreen = [[UIColor alloc ] initWithRed:34/255.0 green:139/255.0 blue:34/255.0 alpha:1.0];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setGroupingSize:3];
    [formatter setGroupingSeparator:@"."];
    [formatter setCurrencySymbol:@""];
    [formatter setMaximumFractionDigits:0];
    [formatter setMinimumFractionDigits:0];
    [formatter setDecimalSeparator:@","];
    [formatter setMinusSign:@"-"];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMultiplier:@1];
    cell.totaleOdierno.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varTotalePeriodo]];
    cell.delta.text = [formatter stringFromNumber:[NSNumber numberWithFloat:varDelta]];
    cell.delta.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [formatter setMultiplier:@100];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    cell.deltaP.text = [NSString stringWithFormat:@"(%@)",[formatter stringFromNumber:[NSNumber numberWithFloat:varDeltaP]]];
    cell.deltaP.textColor = (varDelta < 0) ? [UIColor redColor] : darkGreen;
    
    
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
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if (! indexPath.section) {
        return YES; //Nessun blocco se è il totale
    } else {
        if (totali[sedi[indexPath.row]] != nil) {
            return YES;
        } else {
            return NO;
        }
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Elenco Sedi" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    SediDVC *nextView = [segue destinationViewController];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    nextView.db = _db;
    nextView.societaDict = _societaDict;
    nextView.societaSel = _societaSel;
    nextView.areeDict = _areeDict;
    nextView.areaSel = _areaSel;
    nextView.periodiDict = _periodiDict;
    nextView.periodoSel = _periodoSel;
    nextView.sediDict = _sediDict;
    nextView.sedeSel = sedi[indexPath.row];
    
    if (! indexPath.section) {
        nextView.totale = totali[@"TOTALE"];
    } else {
        nextView.totale = totali[sedi[indexPath.row]];    }
}


#pragma mark - Aggiornamento Incassi

- (void)recuperaIncassoByProxy:(NSString *)codiceNegozio {
    
    soap = [[SOAPEngine alloc]init];
    soap.userAgent = @"SOAPEngine";
    soap.licenseKey = @"TbISCn662T8TX3lSsNU0UOsWrZC6jSJ2ckAyj1cTXY6jQzTWy8yWBDKi6OyGelR3lPTIfHqTf1rxHkZtwsYGAQ==";
    soap.delegate = self;
    soap.actionNamespaceSlash = YES;
    soap.retrievesAttributes = YES;
    soap.responseHeader = YES;
    soap.soapNamespace = [@"IF" stringByAppendingString: codiceNegozio];
    
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Rome"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:tz];*/
    
    [soap setValue:codiceNegozio forKey:@"PROXY_CODICE_SEDE"];
    [soap setValue:_sediDict[codiceNegozio][@"ip"] forKey:@"PROXY_IP"];
    [soap setValue:_periodiDict[_periodoSel][@"data_corrente"] forKey:@"PROXY_DATA_CORRENTE"];
    [soap setValue:_periodiDict[_periodoSel][@"data_inizio"] forKey:@"PROXY_DATA_PARTENZA"];
    [soap setValue:_periodiDict[_periodoSel][@"data_fine"] forKey:@"PROXY_DATA_FINE"];
    [soap setValue:_periodiDict[_periodoSel][@"data_corrente_ap"] forKey:@"PROXY_DATA_CORRENTE_AP"];
    [soap setValue:_periodiDict[_periodoSel][@"data_inizio_ap"] forKey:@"PROXY_DATA_PARTENZA_AP"];
    [soap setValue:_periodiDict[_periodoSel][@"data_fine_ap"] forKey:@"PROXY_DATA_FINE_AP"];
    [soap setRequestTimeout:60];
   
    NSString *url = [[NSString alloc]initWithFormat:@"http://%@:8080/4DSOAP/", _societaDict[_societaSel][@"ip"]];
    
    [soap requestURL:url soapAction:@"A_WebService#ssIncassiProxyCall"];
    
    //NSLog(@"%@", soap);
}



- (IBAction)aggiornamento:(id)sender {
    
    for (NSString *sede in sedi) {
        [self recuperaIncassoByProxy:sede];
    }
}
    
- (void)ricalcoloTotale {
    
    // azzero i totali
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [tempDict setObject:@{@"CODICE_SEDE":@"TOTALE",
                          @"TOTALE_ODIERNO":@0,
                          @"TOTALE_PERIODO":@0,
                          @"TOTALE_MARGINE_PERIODO":@0,
                          @"TOTALE_MARGINE_ODIERNO":@0,
                          @"TOTALE_VENDUTO_IN_PROMO_PERIODO":@0,
                          @"TOTALE_VENDUTO_IN_PROMO_ODIERNO":@0,
                          @"TOTALE_SCONTRINI_ODIERNI":@0,
                          @"TOTALE_SCONTRINI_PERIODO":@0,
                          @"TIPO_APERTURA":@"",
                          @"TOTALE_ORE_LAVORATE":@0,
                          @"TOTALE_ORE_LAVORATE_PERIODO":@0,
                          @"TOTALE_ODIERNO_AP":@0,
                          @"TOTALE_PERIODO_AP":@0,
                          @"TOTALE_MARGINE_PERIODO_AP":@0,
                          @"TOTALE_MARGINE_ODIERNO_AP":@0,
                          @"TOTALE_VENDUTO_IN_PROMO_PERIODO_AP":@0,
                          @"TOTALE_VENDUTO_IN_PROMO_ODIERNO_AP":@0,
                          @"TOTALE_SCONTRINI_PERIODO_AP":@0,
                          @"TOTALE_ORE_LAVORATE_PERIODO_AP":@0,
                          @"ORA_ULTIMO_SCONTRINO":@0,
                          @"TOTALE_PERIODO_OBBIETTIVO_AP":@0,
                          @"TOTALE_PASSAGGI":@0,
                          @"TOTALE_PASSAGGI_ODIERNI":@0,
                          @"TOTALE_PASSAGGI_AP":@0,
                          @"SONO_LA_DIREZIONE":@0,
                          @"GIORNI_DI_APERTURA":@0
                          } forKey:@"TOTALE"];
    
    totali[@"TOTALE"] = tempDict;
    
    float totaleOdierno = 0;
    float totalePeriodo = 0;
    float totaleScontriniOdierni = 0;
    float totaleScontriniPeriodo = 0;
    //float totaleTipoApertura = 0;
    float totaleOreLavorate = 0;
    float totaleOreLavoratePeriodo = 0;
    float totaleOdiernoAP = 0;
    float totalePeriodoAP = 0;
    float totaleScontriniperiodoAP = 0;
    float totaleOreLavoratePeriododAP = 0;
    //float totaleOraUltimoScontrino = 0;
    float totalePeriodoObbiettivoAP = 0;
    float totalePassaggi = 0;
    float totalePassaggiAP = 0;
    //float totaleSonoLaDirezione = 0;
    
    for (NSDictionary *totaleSede in [totali allValues]) {
        if (![totaleSede[@"CODICE_SEDE"] isEqual: @"TOTALE"]) {
            totaleOdierno += [totaleSede[@"TOTALE_ODIERNO"] floatValue];
            totalePeriodo += [totaleSede[@"TOTALE_PERIODO"] floatValue];
            totaleScontriniOdierni += [totaleSede[@"TOTALE_SCONTRINI_ODIERNI"] floatValue];
            totaleScontriniPeriodo += [totaleSede[@"TOTALE_SCONTRINI_PERIODO"] floatValue];
            // totaleTipoApertura += [totaleSede[@"TIPO_APERTURA"] floatValue];
            totaleOreLavorate += [totaleSede[@"TOTALE_ORE_LAVORATE"] floatValue];
            totaleOreLavoratePeriodo += [totaleSede[@"TOTALE_ORE_LAVORATE_PERIODO"] floatValue];
            totaleOdiernoAP += [totaleSede[@"TOTALE_ODIERNO_AP"] floatValue];
            totalePeriodoAP += [totaleSede[@"TOTALE_PERIODO_AP"] floatValue];
            totaleScontriniperiodoAP += [totaleSede[@"TOTALE_SCONTRINI_PERIODO_AP"] floatValue];
            totaleOreLavoratePeriododAP += [totaleSede[@"TOTALE_ORE_LAVORATE_PERIODO_AP"] floatValue];
            //float totaleOraUltimoScontrino += [totaleSede[@"ORA_ULTIMO_SCONTRINO"] floatValue];
            totalePeriodoObbiettivoAP += [totaleSede[@"TOTALE_PERIODO_OBBIETTIVO_AP"] floatValue];
            totalePassaggi += [totaleSede[@"TOTALE_PASSAGGI"] floatValue];
            totalePassaggiAP += [totaleSede[@"TOTALE_PASSAGGI_AP"] floatValue];
            // totaleSonoLaDirezione =  [totaleSede[@"SONO_LA_DIREZIONE"] floatValue];
        }
    }
    
    tempDict[@"TOTALE_ODIERNO"] = [NSNumber numberWithFloat:totaleOdierno];
    tempDict[@"TOTALE_PERIODO"] = [NSNumber numberWithFloat:totalePeriodo];
    tempDict[@"TOTALE_SCONTRINI_ODIERNI"] = [NSNumber numberWithFloat:totaleScontriniOdierni];
    tempDict[@"TOTALE_SCONTRINI_PERIODO"] = [NSNumber numberWithFloat:totaleScontriniPeriodo];
    tempDict[@"TOTALE_ORE_LAVORATE"] = [NSNumber numberWithFloat:totaleOreLavorate];
    tempDict[@"TOTALE_ORE_LAVORATE_PERIODO"] = [NSNumber numberWithFloat:totaleOreLavoratePeriodo];
    tempDict[@"TOTALE_ODIERNO_AP"] = [NSNumber numberWithFloat:totaleOdiernoAP];
    tempDict[@"TOTALE_PERIODO_AP"] = [NSNumber numberWithFloat:totalePeriodoAP];
    tempDict[@"TOTALE_SCONTRINI_PERIODO_AP"] = [NSNumber numberWithFloat:totaleScontriniperiodoAP];
    tempDict[@"TOTALE_ORE_LAVORATE_PERIODO_AP"] = [NSNumber numberWithFloat:totaleOreLavoratePeriododAP];
    tempDict[@"TOTALE_PERIODO_OBBIETTIVO_AP"] = [NSNumber numberWithFloat:totalePeriodoObbiettivoAP];
    tempDict[@"TOTALE_PASSAGGI"] = [NSNumber numberWithFloat:totalePassaggi];
    tempDict[@"TOTALE_PASSAGGI_AP"] = [NSNumber numberWithFloat:totalePassaggiAP];
    
    // e sostituisco il dictionary originale con quello modificato
    totali[@"TOTALE"] = tempDict;
}

@end
