//
//  Search.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "Search.h"



@implementation Search {
    BOOL _isLoading;
    NSMutableArray * _searchResults;
    UITableView * _tableView;
}

-(id) initWithCollection:(NSMutableArray *)array andTableView:(UITableView *)view {
    self = [super init];
    _searchResults = array;
    _tableView = view;
    return self;
}

-(void) runSearchFor:(NSString *)string {
    _isLoading = YES;
    [_tableView reloadData];
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [self urlWithSearchText:string];
        NSString *jsonString = [self performStoreRequestWithURL:url];
        
        if (jsonString == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNetworkError];
            });
            return;
        }
        NSDictionary *dictionary = [self parseJSON:jsonString];
        
        if (dictionary == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNetworkError];
            });
            return;
        }
        
        [self parseDictionaryAndSetResults:dictionary];

        dispatch_async(dispatch_get_main_queue(), ^{
            _isLoading = NO;
            NSLog(@"%d", [_searchResults count]);
            [_tableView reloadData];
        });
        
    });

}

- (NSURL *)urlWithSearchText:(NSString *)searchText {
    NSString *escapedSearchText = [searchText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat: @"http://personal.amorales.us/girls?q[name_cont]=%@", escapedSearchText];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (NSString *)performStoreRequestWithURL:(NSURL *)url {
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

- (void)parseDictionaryAndSetResults:(NSDictionary *)dictionary {
    
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
        [_searchResults addObject:searchResult];
        }
    }
}

@end
