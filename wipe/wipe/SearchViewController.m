//
//  SearchViewController.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

static NSString * const NothingFoundCellIndentifier = @"NoResultsFoundCell";
static NSString * const SearchResultCellIdentifier = @"SearchResultCell";

#import "SearchViewController.h"
#import "Search.h"
#import "SearchResultCell.h"


#import "MainNavigationController.h"


@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)cancelButtonPressed:(id)sender;


@end

@implementation SearchViewController {
    BOOL _isLoading;
    Search * _search;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this is needed to make the keyboard go away when clicking on table
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableClicked)];
    [self.tableView addGestureRecognizer:tapgesture];
    

    self.tableView.rowHeight = 80;
    self.tableView.allowsSelection = NO;
    
    UINib *cellNib = [UINib nibWithNibName:SearchResultCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIndentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIndentifier];
    
    [self.searchTextField becomeFirstResponder];
    self.searchTextField.delegate = self;
    
    _search = [[Search alloc] init];
    [_search refreshStoreKitProductsList];
    
}




-(void)tableClicked
{
    
    [self.searchTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    if (_search.searchResults == nil) {
        return 0;
    }
    else if ([_search.searchResults count] == 0){
        return 1;
    }
    else {
        return [_search.searchResults count];
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_search.searchResults count] == 0) {
        return [tableView dequeueReusableCellWithIdentifier: NothingFoundCellIndentifier forIndexPath:indexPath];
    }
    else {
        SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
        SearchResult *searchResult = _search.searchResults[indexPath.row];
        [cell configureForSearchResult:searchResult];
        cell.buyButton.tag = indexPath.row; // set this for purchasing and knowing which id
        [cell.buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}

- (void)buyButtonTapped:(id)sender {
    UIButton *buyButton = (UIButton *)sender;
    SearchResult *searchResult = _search.searchResults[buyButton.tag];
    [searchResult buyProduct];
}

#pragma mark - Search Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([textField.text length] > 0) {
        [_search runSearchFor:textField.text AndUpdateView:_tableView];
    }
    return YES;
}


- (IBAction)cancelButtonPressed:(id)sender {
    MainNavigationController *navController = (MainNavigationController *) self.navigationController;
    [navController popToRootViewControllerAnimated:YES];
    
}
@end
