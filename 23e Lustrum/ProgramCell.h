//
//  ProgramCell.h
//  23e Lustrum
//
//  Created by Ruud Visser on 3/4/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Program.h"
@interface ProgramCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;


-(void)setProgram:(Program *)program;

@end
