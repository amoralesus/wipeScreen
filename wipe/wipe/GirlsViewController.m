//
//  GirlsViewController.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "GirlsViewController.h"
#import "GirlViewCell.h"
#import "Girl.h"

@interface GirlsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation GirlsViewController {
    NSArray * _girlsRecords;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _girlsRecords = [NSMutableArray arrayWithObjects: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _girlsRecords = [self.seedCoredata allGirlRecords];
    
    UINib *cellNib = [UINib nibWithNibName:@"GirlViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"GirlViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_girlsRecords count];
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GirlViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GirlViewCell"];
    
    Girl * girl = _girlsRecords[indexPath.row];
    [cell configureForGirl:girl];
    return cell;
    
}


@end
