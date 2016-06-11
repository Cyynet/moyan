//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 10.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 5.0f
#define font 10.0f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 2.0f
#define BACKGROUND_COLOR  MYColor(255, 191, 81)
#define TEXT_COLOR subTitleColor
#define TEXT_SHADOW_COLOR [UIColor whiteColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR  UIColorFromRGB(0xc9c9c9).CGColor
#define BORDER_WIDTH 0.50f



@implementation DWTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
        
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    
    [self display];
}

- (void)display
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING * 2 - 5;
        textSize.height += VERTICAL_PADDING * 1;
        UILabel *label = nil;
        if (!gotPreviousFrame) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > MYScreenW - 20)
            {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + 3 + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN ;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:font]];
        if (!lblBackgroundColor) {
            [label setBackgroundColor:MYColor(255, 255, 255)];
        } else {
            [label setBackgroundColor:MYColor(255, 255, 255)];
        }
        [label setTextColor:TEXT_COLOR];
        [label setText:text];
        [label setTextAlignment:UITextAlignmentCenter];
        //        [label setShadowColor:TEXT_SHADOW_COLOR];
        //        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        //        [label.layer setMasksToBounds:YES];
        //        [label.layer setCornerRadius:CORNER_RADIUS];
        
        //        设置边框
                [label.layer setBorderColor:BORDER_COLOR];
                [label.layer setBorderWidth: BORDER_WIDTH];
        
        //        设置圆角
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        
        [self addSubview:label];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight );
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end
