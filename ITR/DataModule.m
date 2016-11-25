//
//  DataModule.m
//  Magazzino
//
//  Created by if65 on 21/08/16.
//  Copyright © 2016 if65. All rights reserved.
//

#import "DataModule.h"
#import <sqlite3.h>
#import "DateHandlingUtilityModule.h"

@interface DataModule ()

@property (strong, nonatomic) NSString *pathDB; //path
@property (strong, nonatomic) NSString *nameDB; //path

@property (strong, nonatomic) NSArray *societaDescrizione;
@property (strong, nonatomic) NSArray *societaIP;

@end

@implementation DataModule {
    DateHandlingUtilityModule *dh;
    NSMutableDictionary *calendario;
}

-(id) init {
    
    if (self = [super init]) {
        
        NSError *error;
        
        //creo una cartella nella cartella Documents del mio Bundle
        _pathDB = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ITR"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_pathDB])
            [[NSFileManager defaultManager] createDirectoryAtPath:_pathDB withIntermediateDirectories:NO attributes:nil error:&error];
        
        _nameDB = @"ITR.db";
        
        dh = [[DateHandlingUtilityModule alloc]init];
        
        calendario = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [self createDB];
    }
    
    return self;
}

#pragma mark -
#pragma mark operazioni sul db
-(void) createDB{
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    NSLog(@"%s", fullPathDB);
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        NSLog(@"%@", @"DB Aperto correttamente!");
        
        // -------------- Societa --------------
        NSString *structureTableSocieta =
        @"CREATE TABLE IF NOT EXISTS `Societa` ( \
        `codice`        TEXT NOT NULL UNIQUE,\
        `descrizione`	TEXT NOT NULL DEFAULT \"\",\
        `ip`            TEXT NOT NULL DEFAULT \"\",\
        PRIMARY KEY(`codice`)\
        ) WITHOUT ROWID;";
        if (sqlite3_exec(sqlDB, [structureTableSocieta UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            //NSLog(@"%s", fullPathDB);
        } else {
            NSLog(@"Error %s while preparing statement Societa", sqlite3_errmsg(sqlDB));
        }
        
        // -------------- Insegne --------------
        NSString *structureTableInsegne =
        @"CREATE TABLE IF NOT EXISTS `Insegne`(\
        `codice`            TEXT NOT NULL UNIQUE,\
        `descrizione`       TEXT NOT NULL DEFAULT \"\", \
        `codice_societa`	TEXT NOT NULL,\
        PRIMARY KEY(codice)\
        ) WITHOUT ROWID";
        if (sqlite3_exec(sqlDB, [structureTableInsegne UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            //NSLog(@"%s", fullPathDB);
        } else {
            NSLog(@"Error %s while preparing statement Insegne", sqlite3_errmsg(sqlDB));
        }
        
        // -------------- Sedi --------------
        NSString *structureTableSedi =
        @"CREATE TABLE IF NOT EXISTS `Sedi`(\
        `codice`            TEXT NOT NULL UNIQUE,\
        `codice_ced`        TEXT NOT NULL UNIQUE,\
        `descrizione`       TEXT NOT NULL DEFAULT \"\",\
        `codice_societa`	TEXT NOT NULL DEFAULT \"\",\
        `codice_insegna`	TEXT NOT NULL DEFAULT \"\",\
        `tipo`              TEXT NOT NULL DEFAULT \"\",\
        `ip`                TEXT NOT NULL DEFAULT \"\",\
        `data_apertura`     TEXT NOT NULL DEFAULT \"0000-00-00\",\
        `data_chiusura`     TEXT NOT NULL DEFAULT \"0000-00-00\",\
        `ordinamento`       INTEGER NOT NULL DEFAULT 0,\
        PRIMARY KEY(codice)\
        ) WITHOUT ROWID;";
        if (sqlite3_exec(sqlDB, [structureTableSedi UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            //NSLog(@"%s", fullPathDB);
        } else {
            NSLog(@"Error %s while preparing statement Sedi", sqlite3_errmsg(sqlDB));
        }
        
        // -------------- Aree --------------
        NSString *structureTableAree =
        @"CREATE TABLE IF NOT EXISTS `Aree`(\
        `codice`            INTEGRER NOT NULL DEFAULT 0,\
        `descrizione`       TEXT NOT NULL DEFAULT \"\",\
        `codice_societa`	TEXT NOT NULL DEFAULT \"\",\
        `codice_insegna`	TEXT NOT NULL DEFAULT \"\",\
        `tipo`              INTEGER NOT NULL DEFAULT 0,\
        `ordinamento`       INTEGER NOT NULL DEFAULT 0,\
        PRIMARY KEY(codice, codice_societa)\
        ) WITHOUT ROWID;";
        if (sqlite3_exec(sqlDB, [structureTableAree UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            //NSLog(@"%s", fullPathDB);
        } else {
            NSLog(@"Error %s while preparing statement Aree", sqlite3_errmsg(sqlDB));
        }
        
        // -------------- Sedi <-> Aree --------------
        NSString *structureTableLinkAreeSedi =
        @"CREATE TABLE IF NOT EXISTS `AreeSedi`(\
        `codice_area`       INTEGER NOT NULL DEFAULT \"\",\
        `codice_sede`       TEXT NOT NULL DEFAULT \"\",\
        `codice_societa`	TEXT NOT NULL DEFAULT \"\",\
        PRIMARY KEY(codice_area, codice_sede)\
        ) WITHOUT ROWID;";
        if (sqlite3_exec(sqlDB, [structureTableLinkAreeSedi UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
            //NSLog(@"%s", fullPathDB);
        } else {
            NSLog(@"Error %s while preparing statement AreeSedi", sqlite3_errmsg(sqlDB));
        }
        
        NSArray *elencoSocieta = @[
                                   @{@"codice":@"01", @"descrizione":@"Italmark S.p.A.", @"ip":@"10.11.14.77"},
                                   @{@"codice":@"07", @"descrizione":@"Sportland S.r.l.", @"ip":@"10.11.14.59"},
                                   @{@"codice":@"08", @"descrizione":@"Supermedia S.p.A.", @"ip":@"11.0.1.31"},
                                   @{@"codice":@"10", @"descrizione":@"Ecobrico S.r.l.", @"ip":@"10.11.14.18"},
                                   @{@"codice":@"53", @"descrizione":@"R.& S. S.r.l.", @"ip":@"10.11.14.57"},
                                   @{@"codice":@"19", @"descrizione":@"Goassist S.r.l.", @"ip":@"10.11.14.141"}
                                   ];
        
        
        [self insertRecordInTableSocietaWithArrayOfSocieta:elencoSocieta];
        sqlite3_close(sqlDB);
    }
}

-(void) resetDB{
    
}

#pragma mark -
#pragma mark aggiornamento dati

-(bool) updateSortAreeWithSocieta:(NSString *)societa andListAree:(NSArray *)aree {
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        
        
        
        const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
        if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
            
            NSString *querySQL = @"update aree set ordinamento = ? where codice_societa = ? and codice = ?";
            
            sqlite3_stmt *statement = nil;
            
            // preparo la query
            if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
                NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            
            //[myArrayOfStrings objectAtIndex:i]
            
            for (int i = 0; i < [aree count]; i++) {
                
                if (sqlite3_bind_int(statement, 1, i*10) != SQLITE_OK) {
                    NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 2, [societa UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_int(statement, 3, [[aree objectAtIndex:i] intValue]) != SQLITE_OK) {
                    NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                // finalizzo & chiudo
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                sqlite3_reset(statement);
                
            }
            sqlite3_finalize(statement);
            sqlite3_close(sqlDB);
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark inserimento dati

-(bool) insertRecordInTableSocietaWithArrayOfSocieta:(NSArray *)societa {
    
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        
        if ([societa count] > 0) {
            
            const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
            if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
                
                NSString *querySQL = @"insert or ignore into Societa(codice, descrizione, ip) values (?,?,?);";
                
                sqlite3_stmt *statement = nil;
                
                // preparo la query
                if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
                    NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                for (NSDictionary *societaDict in societa) {
                    if (sqlite3_bind_text(statement, 1, [societaDict[@"codice"] UTF8String], -1, NULL) != SQLITE_OK) {
                        NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                        return NO;
                    }
                    if (sqlite3_bind_text(statement, 2, [societaDict[@"descrizione"] UTF8String], -1, NULL) != SQLITE_OK) {
                        NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                        return NO;
                    }
                    if (sqlite3_bind_text(statement, 3, [societaDict[@"ip"] UTF8String], -1, NULL) != SQLITE_OK) {
                        NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                        return NO;
                    }
                    
                    // finalizzo & chiudo
                    if (sqlite3_step(statement) != SQLITE_DONE) {
                        NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                        return NO;
                    }
                    
                    sqlite3_reset(statement);
                    
                }
                sqlite3_finalize(statement);
                sqlite3_close(sqlDB);
            }
        }
    }
    return YES;
}

-(bool) insertRecordInTableAreeWithArrayOfAree:(NSArray *)aree andArrayOfLink:(NSArray *)link {
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        
        NSString *querySQL = @" insert or ignore into  Aree(codice, descrizione, codice_societa) values (?,?,?);";
        sqlite3_stmt *statement = nil;
        
        // preparo la query
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
            return NO;
        }
        
        for (NSDictionary *area in aree) {
            if (sqlite3_bind_int(statement, 1, [area[@"ID"] intValue]) != SQLITE_OK) {
                NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_text(statement, 2, [area[@"DESCRIZIONE"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_text(statement, 3, [area[@"CODICE_SOCIETA"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            // finalizzo & chiudo
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        
        
        querySQL = @"update Aree set descrizione = ? where codice = ? and codice_societa = ?;";
        statement = nil;
        
        // preparo la query
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
            return NO;
        }
        
        for (NSDictionary *area in aree) {
            if (sqlite3_bind_text(statement, 1, [area[@"DESCRIZIONE"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_int(statement, 2, [area[@"ID"] intValue]) != SQLITE_OK) {
                NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_text(statement, 3, [area[@"CODICE_SOCIETA"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            // finalizzo & chiudo
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        
        querySQL = @" insert or replace into  AreeSedi(codice_area, codice_sede, codice_societa) values (?,?,?);";
        statement = nil;
        
        // preparo la query
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
            return NO;
        }
        
        for (NSDictionary *areaLink in link) {
            if (sqlite3_bind_int(statement, 1, [areaLink[@"ID_AREA"] intValue]) != SQLITE_OK) {
                NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_text(statement, 2, [areaLink[@"ID_SEDE"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            if (sqlite3_bind_text(statement, 3, [areaLink[@"CODICE_SOCIETA"] UTF8String], -1, NULL) != SQLITE_OK) {
                NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            // finalizzo & chiudo
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            
            sqlite3_reset(statement);
        }
        sqlite3_finalize(statement);
        
        sqlite3_close(sqlDB);
    }
    
    return YES; // se non ci sono record non genera un errore
}

-(bool) insertRecordInTableSediWithArrayOfSedi:(NSArray *)sedi {
    // sedi è un array di Dictionary
    
    if ([sedi count] > 0) {
        
        sqlite3 *sqlDB;
        
        const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
        if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
            
            NSString *querySQL = @" insert or replace into Sedi(codice, codice_ced, descrizione, codice_societa, codice_insegna, tipo, ip, data_apertura, data_chiusura,ordinamento) values (?,?,?,?,?,?,?,?,?,?);";
            
            sqlite3_stmt *statement = nil;
            
            // preparo la query
            if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
                NSLog(@"Prepare failure: %s", sqlite3_errmsg(sqlDB));
                return NO;
            }
            
            for (NSDictionary *sede in sedi) {
                if (sqlite3_bind_text(statement, 1, [sede[@"CODICE"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 2, [sede[@"CODICE_CED"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 2 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 3, [sede[@"DESCRIZIONE"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 3 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                // modifica momentanea valida fino a quando 4D non gestirà le insegne
                NSString *codiceSocieta = sede[@"CODICE_SOCIETA"];
                if ([codiceSocieta isEqualToString:@"00"] || [codiceSocieta isEqualToString:@"04"] || [codiceSocieta isEqualToString:@"31"] || [codiceSocieta isEqualToString:@"36"]) {
                    codiceSocieta = @"01";
                }
                if (sqlite3_bind_text(statement, 4, [codiceSocieta UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 4 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                NSString *codiceInsegna = sede[@"CODICE_INSEGNA"];
                if ([codiceInsegna isEqualToString:@"00"]) {
                    codiceInsegna = @"01";
                }
                if (sqlite3_bind_text(statement, 5, [codiceInsegna UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 5 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                // fine modifica
                
                if (sqlite3_bind_text(statement, 6, [sede[@"TIPO"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 6 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 7, [sede[@"IP"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 7 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 8, [sede[@"DATA_APERTURA"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 8 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_text(statement, 9, [sede[@"DATA_CHIUSURA"] UTF8String], -1, NULL) != SQLITE_OK) {
                    NSLog(@"Bind 9 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                if (sqlite3_bind_int(statement, 10, [@0 intValue]) != SQLITE_OK) {
                    NSLog(@"Bind 10 failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                // finalizzo & chiudo
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    NSLog(@"Step failure: %s", sqlite3_errmsg(sqlDB));
                    return NO;
                }
                
                sqlite3_reset(statement);
            }
            sqlite3_finalize(statement);
            sqlite3_close(sqlDB);
            
            return YES;
        }
        
    }
    return YES;
}


#pragma mark -
#pragma mark liste

-(NSDictionary *) getListPeriodi {
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSDate *oggi = [NSDate date];
    NSString *dataCorrente = [dh dateToStringWithDate:oggi];
    
    NSDate *oggiAP;
    NSString *dataCorrenteAP;
    
    // settimana corrente
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    NSString *dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheWeekWithDate:oggi]];
    NSString *dataFine = [dh dateToStringWithDate:[dh lastDayOfTheWeekWithDate:oggi]];
    
    NSString *dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheWeekWithDate:oggiAP]];
    NSString *dataFineAP = [dh dateToStringWithDate:[dh lastDayOfTheWeekWithDate:oggiAP]];
    
    NSMutableDictionary *record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@1 forKey:@"posizione"];
    [record setValue:@"Settimana Corrente" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    

    // mese corrente
    // ------------------------------------------------------
    oggiAP = [dh sameDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheMonthWithDate:oggi]];
    dataFine = [dh dateToStringWithDate:[dh lastDayOfTheMonthWithDate:oggi]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheMonthWithDate:oggiAP]];
    dataFineAP = [dh dateToStringWithDate:[dh lastDayOfTheMonthWithDate:oggiAP]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@2 forKey:@"posizione"];
    [record setValue:@"Mese Corrente" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    

    // anno corrente
    // ------------------------------------------------------
    oggiAP = [dh sameDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheYearWithDate:oggi]];
    dataFine = [dh dateToStringWithDate:[dh lastDayOfTheYearWithDate:oggi]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheYearWithDate:oggiAP]];
    dataFineAP = [dh dateToStringWithDate:[dh lastDayOfTheYearWithDate:oggiAP]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@3 forKey:@"posizione"];
    [record setValue:@"Anno Corrente" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
    // anno mobile
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheMobileYearWithDate:oggi]];
    dataFine = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheMobileYearWithDate:oggiAP]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@4 forKey:@"posizione"];
    [record setValue:@"Anno Mobile" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    // ultimo giorno
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    dataFine = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@5 forKey:@"posizione"];
    [record setValue:@"Ultimo Giorno" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    // ultimi due giorni
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-2]];
    dataFine = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-2]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@6 forKey:@"posizione"];
    [record setValue:@"Ultimi Due Giorni" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
    // ultimi tre giorni
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-3]];
    dataFine = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-3]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@7 forKey:@"posizione"];
    [record setValue:@"Ultimi Tre Giorni" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
    // ultimi quattro giorni
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-4]];
    dataFine = [dh dateToStringWithDate:[dh addToDate:oggi andNumberOfDays:-1]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-4]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate:oggiAP andNumberOfDays:-1]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@8 forKey:@"posizione"];
    [record setValue:@"Ultimi Quattro Giorni" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
    
    // ultima settimana
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate: [dh firstDayOfTheWeekWithDate:oggi] andNumberOfDays:-7]];
    dataFine = [dh dateToStringWithDate:[dh addToDate: [dh lastDayOfTheWeekWithDate:oggi] andNumberOfDays:-7]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate: [dh firstDayOfTheWeekWithDate:oggiAP] andNumberOfDays:-7]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate: [dh lastDayOfTheWeekWithDate:oggiAP] andNumberOfDays:-7]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@9 forKey:@"posizione"];
    [record setValue:@"Ultima Settimana" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    

    // ultime due settimane
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    dataInizio = [dh dateToStringWithDate:[dh addToDate: [dh firstDayOfTheWeekWithDate:oggi] andNumberOfDays:-14]];
    dataFine = [dh dateToStringWithDate:[dh addToDate: [dh lastDayOfTheWeekWithDate:oggi] andNumberOfDays:-7]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh addToDate: [dh firstDayOfTheWeekWithDate:oggiAP] andNumberOfDays:-14]];
    dataFineAP = [dh dateToStringWithDate:[dh addToDate: [dh lastDayOfTheWeekWithDate:oggiAP] andNumberOfDays:-7]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@10 forKey:@"posizione"];
    [record setValue:@"Ultime Due Settimane" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
    // ultimo mese
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    dataCorrenteAP = [dh dateToStringWithDate:oggiAP];
    
    NSDate *lastDateOfTheMonth = [dh addToDate:[dh firstDayOfTheMonthWithDate:oggi]  andNumberOfDays:-1];
    
    dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheMonthWithDate:lastDateOfTheMonth]];
    dataFine = [dh dateToStringWithDate:lastDateOfTheMonth];
    
    NSDate *lastDateOfTheMonthAP = [dh addToDate:[dh firstDayOfTheMonthWithDate:oggiAP]  andNumberOfDays:-1];
    
    dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheMonthWithDate:lastDateOfTheMonthAP]];
    dataFineAP = [dh dateToStringWithDate:lastDateOfTheMonthAP];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@11 forKey:@"posizione"];
    [record setValue:@"Ultimo Mese" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    // ultimo anno
    // ------------------------------------------------------
    oggiAP = [dh equivalentDayOfTheLastYearWithDate:oggi];
    
    dataInizio = [dh dateToStringWithDate:[dh firstDayOfTheYearWithDate:oggiAP]];
    dataFine = [dh dateToStringWithDate:[dh lastDayOfTheYearWithDate:oggiAP]];
    
    dataInizioAP = [dh dateToStringWithDate:[dh firstDayOfTheYearWithDate:[dh equivalentDayOfTheLastYearWithDate:oggiAP]]];
    dataFineAP = [dh dateToStringWithDate:[dh lastDayOfTheYearWithDate:[dh equivalentDayOfTheLastYearWithDate:oggiAP]]];
    
    record = [[NSMutableDictionary alloc]initWithCapacity:0];
    [record setValue:@12 forKey:@"posizione"];
    [record setValue:@"Ultimo Anno" forKey:@"descrizione"];//<----------
    [record setValue:dataInizio forKey:@"data_inizio"];
    [record setValue:dataFine forKey:@"data_fine"];
    [record setValue:dataCorrente forKey:@"data_corrente"];
    [record setValue:dataInizioAP forKey:@"data_inizio_ap"];
    [record setValue:dataFineAP forKey:@"data_fine_ap"];
    [record setValue:dataCorrenteAP forKey:@"data_corrente_ap"];
    [resultDict setObject:record forKey:record[@"descrizione"]];
    
    
     /*NSLog(@"%@", dataCorrente);
     NSLog(@"%@", dataInizio);
     NSLog(@"%@", dataFine);
     NSLog(@"%@", dataCorrenteAP);
     NSLog(@"%@", dataInizioAP);
     NSLog(@"%@", dataFineAP);*/
   
    return resultDict;
}

-(NSDictionary *) getListSocieta {

    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        
        NSString *querySQL = @"select s.codice, s.descrizione, s.ip, (select count(*) from Sedi as n  where n.tipo in ('03','04') and (n.data_chiusura = '0000-00-00' or date(n.data_chiusura) >= date('now','start of year','-1 year')) and s.codice = n.codice_societa) from societa as s";
        
        sqlite3_stmt *statement;
        
        // preparo la query
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *codice = (char *) sqlite3_column_text(statement, 0);
                char *descrizione = (char *) sqlite3_column_text(statement, 1);
                char *ip = (char *) sqlite3_column_text(statement, 2);
                int count = sqlite3_column_int(statement, 3);
                
                NSMutableDictionary *record =  [[NSMutableDictionary alloc]initWithCapacity:0];
                [record setValue:[[NSString alloc] initWithUTF8String:codice] forKey:@"codice"];
                [record setValue:[[NSString alloc] initWithUTF8String:descrizione] forKey:@"descrizione"];
                [record setValue:[[NSString alloc] initWithUTF8String:ip] forKey:@"ip"];
                [record setValue:[[NSNumber alloc] initWithInt:count] forKey:@"numero_sedi"];
                
                [resultDict setObject:record forKey:[[NSString alloc] initWithUTF8String:codice]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(sqlDB);
    }
    return resultDict;
}

-(NSDictionary *) getListAreeWithSocieta:(NSString *)societa {
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        sqlite3_stmt *statement;
        
        // Aree normali
        NSString *querySQL = @" select a.codice, a.descrizione, a.codice_insegna, a.ordinamento, count(*) \
        from aree as a join AreeSedi as s on a.codice=s.codice_area and a.codice_societa = s.codice_societa \
        where a.codice_societa = ? \
        group by a.codice order by a.ordinamento;";
        
        // preparo la query
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_bind_text(statement, 1, [societa UTF8String], -1, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int codice = sqlite3_column_int(statement, 0);
                    char *descrizione = (char *) sqlite3_column_text(statement, 1);
                    char *codice_insegna = (char *) sqlite3_column_text(statement, 2);
                    int ordinamento = sqlite3_column_int(statement, 3);
                    int numero_sedi = sqlite3_column_int(statement, 4);
                    
                    NSMutableDictionary *record =  [[NSMutableDictionary alloc]initWithCapacity:0];
                    [record setValue:[[NSNumber alloc] initWithInt:codice] forKey:@"codice"];
                    [record setValue:[[[NSString alloc] initWithUTF8String:descrizione]capitalizedString] forKey:@"descrizione"];
                    [record setValue:[[NSString alloc] initWithUTF8String:codice_insegna] forKey:@"codice_insegna"];
                    [record setValue:[[NSNumber alloc] initWithInt:ordinamento] forKey:@"ordinamento"];
                    [record setValue:[[NSNumber alloc] initWithInt:numero_sedi] forKey:@"numero_sedi"];
                    
                    [resultDict setObject:record forKey:[[NSNumber alloc] initWithInt:codice]];//<- qui viene caricata la lista
                }
            } else {
                NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
            }
            sqlite3_finalize(statement);
        }
        
        querySQL = @"select count(*) from Sedi where codice_societa = ? and (tipo = '03' or tipo = '04')";
        
        if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_bind_text(statement, 1, [societa UTF8String], -1, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int count = sqlite3_column_int(statement, 0);
                    
                    NSMutableDictionary *record =  [[NSMutableDictionary alloc]initWithCapacity:0];
                    [record setValue:@1000 forKey:@"codice"];
                    [record setValue:@"TUTTE LE SEDI" forKey:@"descrizione"];
                    [record setValue:@"" forKey:@"codice_insegna"];
                    [record setValue:@-1000 forKey:@"ordinamento"];
                    [record setValue:[[NSNumber alloc] initWithInt:count] forKey:@"numero_sedi"];
                    
                    [resultDict setObject:record forKey:@1000]; //<- qui viene caricata la lista
                }
            } else {
                NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(sqlDB);
    }
    
    return resultDict;
}

-(NSDictionary *) getListSediWithArea:(NSNumber *)area andSocieta:(NSString *)societa andInsegna:(NSString *)insegna {
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    sqlite3 *sqlDB;
    
    const char *fullPathDB = [[_pathDB stringByAppendingPathComponent:_nameDB] UTF8String];
    if (sqlite3_open(fullPathDB, &sqlDB) == SQLITE_OK) {
        sqlite3_stmt *statement;
        
        NSString *querySQL;
        
        if ([insegna isEqualToString:@""]) {
            
            
            if ([area  isEqual: @1000]) {
                querySQL = @"select codice, codice_ced, descrizione, ip, ordinamento \
                from Sedi where codice_societa = ? and tipo in ('03','04') and (data_chiusura = '0000-00-00' or date(data_chiusura) >= date('now','start of year','-1 year')) \
                order by ordinamento";
                if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_bind_text(statement, 1, [societa UTF8String], -1, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            char *codice = (char *) sqlite3_column_text(statement, 0);
                            char *codice_ced = (char *) sqlite3_column_text(statement, 1);
                            char *descrizione = (char *) sqlite3_column_text(statement, 2);
                            char *ip = (char *) sqlite3_column_text(statement, 3);
                            int ordinamento = sqlite3_column_int(statement, 4);
                            
                            NSMutableDictionary *record =  [[NSMutableDictionary alloc]initWithCapacity:0];
                            [record setValue:[[NSString alloc] initWithUTF8String:codice] forKey:@"codice"];
                            [record setValue:[[NSString alloc] initWithUTF8String:codice_ced] forKey:@"codice_ced"];
                            [record setValue:[[NSString alloc] initWithUTF8String:descrizione] forKey:@"descrizione"];
                            [record setValue:[[NSString alloc] initWithUTF8String:ip] forKey:@"ip"];
                            [record setValue:[[NSNumber alloc] initWithInt:ordinamento] forKey:@"ordinamento"];
                            [resultDict setObject:record forKey:[[NSString alloc] initWithUTF8String:codice]];
                        }
                    } else {
                        NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                    }
                    sqlite3_finalize(statement);
                }
            } else {
                querySQL = @"select s.codice, s.codice_ced, s.descrizione, s.ip, s.ordinamento \
                from AreeSedi as a left join Sedi as s on a.codice_sede = s.codice \
                where a.codice_area = ? and s.codice_societa = ? and s.tipo in ('03','04') and \
                (data_chiusura = '0000-00-00' or date(data_chiusura) >= date('now','start of year','-1 year')) \
                order by ordinamento";
                if (sqlite3_prepare_v2(sqlDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                    if (sqlite3_bind_int(statement, 1, [area intValue]) == SQLITE_OK && sqlite3_bind_text(statement, 2, [societa UTF8String], -1, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            char *codice = (char *) sqlite3_column_text(statement, 0);
                            char *codice_ced = (char *) sqlite3_column_text(statement, 1);
                            char *descrizione = (char *) sqlite3_column_text(statement, 2);
                            char *ip = (char *) sqlite3_column_text(statement, 3);
                            int ordinamento = sqlite3_column_int(statement, 4);
                            
                            NSMutableDictionary *record =  [[NSMutableDictionary alloc]initWithCapacity:0];
                            [record setValue:[[NSString alloc] initWithUTF8String:codice] forKey:@"codice"];
                            [record setValue:[[NSString alloc] initWithUTF8String:codice_ced] forKey:@"codice_ced"];
                            [record setValue:[[NSString alloc] initWithUTF8String:descrizione] forKey:@"descrizione"];
                            [record setValue:[[NSString alloc] initWithUTF8String:ip] forKey:@"ip"];
                            [record setValue:[[NSNumber alloc] initWithInt:ordinamento] forKey:@"ordinamento"];
                            [resultDict setObject:record forKey:[[NSString alloc] initWithUTF8String:codice]];
                        }
                    } else {
                        NSLog(@"Bind 1 failure: %s", sqlite3_errmsg(sqlDB));
                    }
                    sqlite3_finalize(statement);
                }
            }
        }
        sqlite3_close(sqlDB);
    }
    
    return resultDict;
    
}


@end
