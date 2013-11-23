//
//  SearchViewController.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchViewController.h"
#import "Search.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation SearchViewController {
    NSMutableArray * _searchResults;
    Search * _search;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _searchResults = [NSMutableArray arrayWithObjects: nil];
        _search = [[Search alloc]initWithCollection:_searchResults andTableView:self.tableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // move the table view down a bit to allow the first rows to show under the search bar
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if([searchBar.text length] > 0) {
        [_search runSearchFor:searchBar.text];
    }
}

@end
