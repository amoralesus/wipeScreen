//
//  SearchResultCell.m
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "SearchResultCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

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


- (void)configureForSearchResult:(SearchResult *)searchResult {
    self.nameLabel.text = searchResult.name;
    
    self.descriptionLabel.text = searchResult.description;
    
    [self.avatar setImageWithURL:[NSURL URLWithString:[searchResult productURL]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    
}

@end
