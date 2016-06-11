//
//  JWSearchBar.m
//
//
//  Created by 👄.
//

#import "MYSearchBar.h"
#import "MYHeader.h"


@implementation MYSearchBar


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 背景
        self.background = [UIImage resizableImage:@"searchbar_textfield_background"];
        
        // 添加放大镜
        UIImageView *leftView = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
        leftView.width = leftView.width + 10;
        leftView.height = leftView.height;
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 显示清楚按钮
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.adjustsFontSizeToFitWidth = YES;
        
        // iOS6文字不会垂直居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc]init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

}

@end
