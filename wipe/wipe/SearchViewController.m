//
//  SearchViewController.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchViewController.h"
#import "Search.h"
#import "SearchResultCell.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController {
    NSMutableArray * _searchResults;
    BOOL _isLoading;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchResults = [NSMutableArray arrayWithObjects: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // move the table view down a bit to allow the first rows to show under the search bar
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.rowHeight = 80;
    
    UINib *cellNib = [UINib nibWithNibName:@"SearchResultCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SearchResultCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"which object%@", _searchResults);
    
    if (_searchResults == nil) {
        return 0;
    }
    else if ([_searchResults count] == 0){
        return 1;
    }
    else {
        return [_searchResults count];
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if([_searchResults count] == 0) {
        cell.nameLabel.text = @"Nothing";
        cell.detailTextLabel.text = @"nothing";
    }
    else {
        SearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.descriptionLabel.text = searchResult.description;
    }
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if([searchBar.text length] > 0) {
        [self runSearchFor:searchBar.text];
    }
}


// could not figure out a way to put this method in the Search class
-(void) runSearchFor:(NSString *)string {
    _isLoading = YES;
    [_tableView reloadData];
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    Search * search = [[Search alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [search urlWithSearchText:string];
        NSString *jsonString = [search performStoreRequestWithURL:url];
        if (jsonString == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [search showNetworkError];
            });
            return;
        }
        NSDictionary *dictionary = [search parseJSON:jsonString];
        
        if (dictionary == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [search showNetworkError];
            });
            return;
        }
        _searchResults = [search parseDictionaryAndSetResults:dictionary];
        NSLog(@"returns %d", [_searchResults count]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _isLoading = NO;
            [_tableView reloadData];
        });
    });
}

@end
