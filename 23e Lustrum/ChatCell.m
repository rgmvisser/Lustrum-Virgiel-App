//
//  MiddleCell.m
//  23e Lustrum
//
//  Created by Ruud Visser on 3/18/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "ChatCell.h"
#import "Fonts.h"
@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setMessageText:(NSString *)message
{
    [Fonts setStaticBold:self.message];
    [Fonts setStaticBold:self.timeLabel];
    [self.message setText:message];
    [self.message setLineBreakMode:NSLineBreakByWordWrapping];
    //[self.message sizeToFit];
    [self.message setClipsToBounds:YES];
    //NSLog(@"Rect:%@",NSStringFromCGRect(self.message.frame));
    
}

-(void)setLeftAlign
{
    
    [self.message setTextAlignment:NSTextAlignmentLeft];
}

-(void)setRightAlign
{
    [self.message setTextAlignment:NSTextAlignmentRight];
}


- (void)setLeft{
    UIImage *left = [[UIImage imageNamed:@"bottom_chat"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
    [self.image setImage:left];
}

-(void)setRight{
    UIImage *left = [[UIImage imageNamed:@"bottom_chat_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
    [self.image setImage:left];
}

-(void)setMiddle{
    [self.image setImage:[UIImage imageNamed:@"middle_chat"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
