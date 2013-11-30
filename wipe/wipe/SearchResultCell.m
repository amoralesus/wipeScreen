//
//  SearchResultCell.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchResultCell.h"


@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)buyButtonPressed:(id)sender {
    
}

- (void)configureForSearchResult:(SearchResult *)searchResult {
    self.nameLabel.text = searchResult.name;
    
    self.descriptionLabel.text = searchResult.description;
    
    NSURL *url = [NSURL URLWithString:[searchResult productURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [self.avatar setImage:image];
    
    if ([searchResult productPurchased] == YES) {
        [self.buyButton setEnabled:NO];
        [self.buyButton setTitle:@"√" forState:UIControlStateDisabled];

    }
    else {
        // buy button is there by default
    }
}



-(void) hideBuyButton {
    self.buyButton.hidden = TRUE;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    
    double red = 254;
    double green = 154;
    double blue = 187;
    
    selectedView.backgroundColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:0.5f];
    self.selectedBackgroundView = selectedView;
}


@end
