//
//  Search.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "Search.h"



@implementation Search 

- (NSURL *)urlWithSearchText:(NSString *)searchText {
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat: @"http://personal.amorales.us/girls?q[name_cont]=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (NSString *)performRequestWithURL:(NSURL *)url {
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (resultString == nil) {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    return resultString;
}

- (void)showNetworkError {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoops..." message:@"There was an error reading from Server. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (NSDictionary *)parseJSON:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (resultObject == nil) {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    if (![resultObject isKindOfClass:[NSDictionary class]]) {
        NSLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    
    return resultObject;
}

- (NSMutableArray *)parseDictionaryAndSetResults:(NSDictionary *)dictionary {
    
    NSMutableArray * results = [NSMutableArray arrayWithObjects: nil];
    
    NSArray *array = dictionary[@"results"];
    if (array == nil) {
        NSLog(@"Expected 'results' array");
    }
    else {
    
    for (NSDictionary *resultDict in array) {
        SearchResult *searchResult = [[SearchResult alloc] init];
        searchResult.name = resultDict[@"name"];
        searchResult.description = resultDict[@"description"];
        searchResult.productCode = resultDict[@"product_code"];
        [results addObject:searchResult];
        }
    }
    return results;
}


// not asynchronous
-(NSArray *) getAllRecords {
    NSURL *url = [self urlForAllRecords];
    NSString *jsonString = [self performRequestWithURL:url];
    NSDictionary *dictionary = [self parseJSON:jsonString];
    return [self parseDictionaryAndSetResults:dictionary];
}

-(NSSet *) setWithAllProductIdentifiers {
    NSMutableArray *array = [NSMutableArray arrayWithObjects: nil];
    for (SearchResult *result in [self getAllRecords]) {
        [array addObject:result.productCode];
    }
    return [NSSet setWithArray:array];
}

- (NSURL *)urlForAllRecords {
    NSString *urlString = [NSString stringWithFormat: @"http://personal.amorales.us/girls?q[id_greater_than]=0"];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}


@end
