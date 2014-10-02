//
//  MiddleCell.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/18/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

-(void)setMessageText:(NSString *)message;
-(void)setLeftAlign;
-(void)setRightAlign;

-(void)setLeft;
-(void)setRight;
-(void)setMiddle;

@end
