//
//  GirlViewCell.m
//  wipe
//
//  Created by Alberto Morales on 11/24/13.
//  Copyright (c) 2013 wipemyscreenclean.com. All rights reserved.
//

#import "GirlViewCell.h"


@implementation GirlViewCell

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

- (void)configureForGirl:(Girl *)girl {
    self.nameLabel.text = girl.name;
    
    self.descriptionLabel.text = girl.girlDescription;
    
    //[self.avatar setImageWithURL:[NSURL URLWithString:[searchResult productURL]] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
    
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
