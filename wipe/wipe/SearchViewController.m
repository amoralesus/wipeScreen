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

#import "WipeIAPHelper.h"
#import <StoreKit/StoreKit.h>

#import "MainNavigationController.h"


@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (IBAction)cancelButtonPressed:(id)sender;


@end

@implementation SearchViewController {
    NSMutableArray * _searchResults;
    BOOL _isLoading;
    NSArray * _sk_products;
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
    
    [self refreshStoreKitProductsList];
}

- (void)refreshStoreKitProductsList {
    _sk_products = nil;
    [[WipeIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _sk_products = products;
        }
    }];
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
    
    if([_searchResults count] == 0) {
        return [tableView dequeueReusableCellWithIdentifier: NothingFoundCellIndentifier forIndexPath:indexPath];
    }
    else {
        SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
        SearchResult *searchResult = _searchResults[indexPath.row];
        [cell configureForSearchResult:searchResult];
        cell.buyButton.tag = indexPath.row; // set this for purchasing and knowing which id
        [cell.buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
}

- (void)buyButtonTapped:(id)sender {
    UIButton *buyButton = (UIButton *)sender;
    SearchResult *searchResult = _searchResults[buyButton.tag];
    SKProduct *product = [self findSKProductWithIdentifier:searchResult.productCode];
    NSLog(@"the product: %@", product);
    [[WipeIAPHelper sharedInstance] buyProduct:product];
}

-(SKProduct *) findSKProductWithIdentifier:(NSString *) identifier {
    for (SKProduct * theProduct in _sk_products) {
        if ([theProduct.productIdentifier isEqualToString: identifier]) {
            return theProduct;
        }
    }
    return nil;
}


#pragma mark - Search Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if([textField.text length] > 0) {
        [self runSearchFor:textField.text];
        NSLog(@"%@", textField.text);
    }
    return YES;
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
        NSString *jsonString = [search performRequestWithURL:url];
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _isLoading = NO;
            [_tableView reloadData];
        });
    });
}


- (IBAction)cancelButtonPressed:(id)sender {
    MainNavigationController *navController = (MainNavigationController *) self.navigationController;
    [navController popToRootViewControllerAnimated:YES];
    
}
@end
