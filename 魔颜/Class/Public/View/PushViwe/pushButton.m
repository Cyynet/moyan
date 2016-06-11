//
//  pushButton.m
//  animationOne
//
//  Created by 战明 on 16/5/15.
//  Copyright © 2016年 zhanming. All rights reserved.
//

#import "pushButton.h"

static CGFloat kTextTopPadding = 10;

@implementation pushButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
//    self.imageView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
//    self.imageView.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    self.titleLabel.frame=CGRectMake(CGRectGetMidX(self.imageView.frame), CGRectGetMaxY(self.imageView.frame), self.frame.size.width, 20);
//    
//    self.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    // Move the image to the top and center it horizontally
//    CGRect imageFrame = self.imageView.frame;
//    imageFrame.origin.y = 0;
//    imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
//    self.imageView.frame = imageFrame;
//    
//    // Adjust the label size to fit the text, and move it below the image
    CGRect titleLabelFrame = self.titleLabel.frame;
    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                                        constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
    titleLabelFrame.size.width = labelSize.width;
    titleLabelFrame.size.height = labelSize.height;
    titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
    titleLabelFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + kTextTopPadding;
    self.titleLabel.frame = titleLabelFrame;

}


@end
