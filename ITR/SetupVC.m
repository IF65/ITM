//
//  SetupVC.m
//  ITR
//
//  Created by if65 on 25/09/2016.
//  Copyright © 2016 if65. All rights reserved.
//

#import "SetupVC.h"

@interface SetupVC ()
    @property (strong, nonatomic) DataModule *db;
@end

@implementation SetupVC {
    SOAPEngine *soap;
    NSArray *societa;
    NSDictionary *societaDict;
    int contatoreAggiornamento;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _db = [[DataModule alloc]init];
    
    societaDict = [_db getListSocieta];
    societa = [[societaDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    contatoreAggiornamento = 0;
    
    [_activityIndicator hidesWhenStopped];
    [_activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - SOAPEngine Delegates

- (void)soapEngine:(SOAPEngine *)soapEngine didFinishLoading:(NSString *)stringXML dictionary:(NSDictionary *)dict {
    
    NSString *responseDict = dict[@"Body"][@"ssSetupProxyServerResponse"][@"RISPOSTA"][@"value"];
    
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [responseDict dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
    
    NSArray *sedi = [[NSArray alloc]initWithArray:JSON[@"SEDI"]];
    NSArray *aree = [[NSArray alloc]initWithArray:JSON[@"AREE"]];
    NSArray *areeLink = [[NSArray alloc]initWithArray:JSON[@"AREELINK"]];
    
    [_db insertRecordInTableSediWithArrayOfSedi:sedi];
    [_db insertRecordInTableAreeWithArrayOfAree:aree andArrayOfLink:areeLink];
    
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
    
    contatoreAggiornamento--;
    if (! contatoreAggiornamento) [_activityIndicator stopAnimating];
    
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
    
    contatoreAggiornamento--;
    if (! contatoreAggiornamento) [_activityIndicator stopAnimating];
}


- (IBAction)aggiornamentoAutomatico:(id)sender {
    
    if (! contatoreAggiornamento) {
        [_activityIndicator startAnimating];
        
        
        contatoreAggiornamento = (int)[societa count];
        
        for (NSString *codiceSocieta in societa) {
            [self updateDatabaseForSocieta:codiceSocieta];
        }
    }
    
}

-(void)updateDatabaseForSocieta:(NSString*)codiceSocieta {
    
    soap = [[SOAPEngine alloc]init];
    soap.userAgent = @"SOAPEngine";
    soap.licenseKey = @"TbISCn662T8TX3lSsNU0UOsWrZC6jSJ2ckAyj1cTXY6jQzTWy8yWBDKi6OyGelR3lPTIfHqTf1rxHkZtwsYGAQ==";
    soap.delegate = self;
    soap.actionNamespaceSlash = YES;
    soap.retrievesAttributes = YES;
    soap.responseHeader = YES;
   
    [soap setValue:codiceSocieta forKey:@"PROXY_CODICE_SOCIETA"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://%@:8080/4DSOAP/", societaDict[codiceSocieta][@"ip"]];
    [soap requestURL:url soapAction:@"A_WebService#ssSetupProxyServer"];
    
    NSLog(@"%@", url);
    
}


@end
