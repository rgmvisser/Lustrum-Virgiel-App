//
//  ProgramCell.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/4/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "ProgramCell.h"
#import "Fonts.h"
@implementation ProgramCell

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

-(void)setProgram:(Program *)program
{
    self.eventName.text = program.title;
    self.eventImage.image = program.image;
    
    [Fonts setStaticBold:self.eventName];
    
}

@end
