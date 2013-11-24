//
//  SearchResultCell.h
//  wipe
//
//  Created by Alberto Morales on 11/23/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UIImageView *avatar;


- (void)configureForSearchResult:(SearchResult *)searchResult;

@end
