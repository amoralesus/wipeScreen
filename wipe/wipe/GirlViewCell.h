//
//  GirlViewCell.h
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Girl.h"

@interface GirlViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;


- (void)configureForGirl:(Girl *)girl;

@end
