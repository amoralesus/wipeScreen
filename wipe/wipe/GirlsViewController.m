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
#import "VideoPlayer.h"

@interface GirlsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation GirlsViewController {
    NSArray * _girlsRecords;
    VideoPlayer *_videoPlayer;
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
    
    self.tableView.rowHeight = 80;
    
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // here we play movie
    
    NSString * movieFileBasename = [_girlsRecords[indexPath.row] productVideo];

    [self playMovie: movieFileBasename];
    
}

-(void) playMovie:(NSString *) filename {
    _videoPlayer = [[VideoPlayer alloc] init];
    [_videoPlayer playMovie:filename inView:self.view];

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_girlsRecords count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}



@end
