//
//  THEditPhotoView.m
//  WangQiuJia-1-2015
//
//  Created by 王鑫 on 16/3/7.
//  Copyright © 2016年 网球家. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THRemoveButton :UIButton
@property(weak,nonatomic) UIButton *removeBtn;

@end

@implementation THRemoveButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *removeBtn = [[UIButton alloc]init];
        [removeBtn addTarget:self action:@selector(removeImageIcon:) forControlEvents:UIControlEventTouchUpInside];
        [removeBtn setImage:[UIImage imageNamed:@"buttonCloseClick"] forState:UIControlStateNormal];
        [self addSubview:removeBtn];
        self.removeBtn = removeBtn;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat removeW = 36;
    CGFloat removeH = removeW;
    CGFloat removeX = self.width - removeW / 2;
    CGFloat removeY = -18;
    self.removeBtn.frame = CGRectMake(removeX, removeY, removeW, removeH);
}
-(void)removeImageIcon:(UIButton *)button{
    //    NSLog(@"--removeImageIcon--");
    UIButton *willDisBtn = (UIButton *)button.superview;
    //    [button.superview removeFromSuperview];
    //当某张图片删除时候，我们发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeleteAPicFromView" object:nil userInfo:@{@"obj":willDisBtn}];
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.removeBtn convertPoint:point fromView:self];
    if ([self.removeBtn pointInside:buttonPoint withEvent:event]) {
        return _removeBtn;
    }
    return result;
}
@end

#import "THEditPhotoView.h"
#import "UIAlertViewTool.h"

static NSInteger const kMaxColumn = 3;           //最大列数
static NSInteger const pMargin = 15;         //图片之间-间距
#define CWScreenW [UIScreen mainScreen].bounds.size.width
#define kImageViewWidth (CWScreenW - (4*pMargin))/3.0 //图片的宽度

@interface THEditPhotoView ()

/**  提示文字 */
@property(weak,nonatomic) UILabel *noticeLab;

/**  加号按钮 */
@property(strong,nonatomic) UIButton *addBtn;

/**  用于存放照片的控制器 */
//@property(nonatomic,strong)NSMutableArray *photoes;
@end
@implementation THEditPhotoView
-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]init];
        _addBtn.adjustsImageWhenHighlighted = NO;
        [_addBtn addTarget:self action:@selector(addImages:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
-(NSMutableArray *)photoes{
    if (!_photoes) {
        _photoes = [[NSMutableArray alloc]init];
    }
    return _photoes;
}
#pragma mark - 初始化
+ (id)editPhotoView{

    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self createSubviews];
//        self.photoes = [NSMutableArray array];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self createSubviews];
    }
    return self;
}

-(void)addimageArr:(NSMutableArray*)arr
{
    for (int i=0; i<arr.count; i++) {
        
        [self.photoes addObject:arr[i]];
        
    }
    [self createSubviews];

}

/**  创建子view */
-(void)createSubviews{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPostNofificationForDeletePic:) name:@"kDeleteAPicFromView" object:nil];
    //添加一个提示按钮
    UILabel *noticeLab = [[UILabel alloc]init];
    //    noticeLab.textColor = [UIColor redColor]
    [self addSubview:noticeLab];
    noticeLab.text = @"为了照片质量，请有限制发图数量(0/6)";

    noticeLab.font = [UIFont systemFontOfSize:12];
    self.noticeLab = noticeLab;
    
    self.backgroundColor = MYBgColor;
    /**  添加加号图片 */
    [self.photoes addObject:[UIImage imageNamed:@"edit"]];
    //添加button
    for (int i = 0; i<self.photoes.count; i++) {
        UIButton *button = nil;
        if (self.photoes.count == i+1) {
            //最后一个用来添加图片
            button = self.addBtn;
        }
        else{
            //在button上添加一个删除按钮
            button = [[THRemoveButton alloc]init];
        }
        //        button.tag  = i+1;
        button.contentMode = UIViewContentModeCenter;
        [button setImage:self.photoes[i] forState:UIControlStateNormal];
        [self addSubview:button];
    }
    
}
#pragma mark - 删除图片的通知处理事件和移除通知监听
-(void)GetPostNofificationForDeletePic:(NSNotification *)noti{

    
    UIButton *button = noti.userInfo[@"obj"];
    //获取tag,然后删除数组中的元素,开始的tag = 46（不能算lable）
    NSInteger concreteNo =  (button.tag - 46)+1;
    //先从照片中remove ,然后是数组
    //调整布局
    [UIView animateWithDuration:0.5 animations:^{
        [self.photoes removeObjectAtIndex:(concreteNo-1)];
        [button removeFromSuperview];
        //删除照片的时候，我们判断的数量，添加“+”
        BOOL isShow = [self.subviews containsObject:self.addBtn];
        if (self.photoes.count == 8 && !isShow) {
            [self.photoes addObject:[UIImage imageNamed:@"edit"]];
            [self addSubview:self.addBtn];
        }
        
    } completion:^(BOOL finished) {
        [self updateNoticeText];
        [self setNeedsLayout];
    }];
    
}

#pragma mark - 添加图片
-(void)addImages:(UIButton *)button
{
    //隐藏所有键盘：
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
    
        UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                                cancelButtonTitle:@"取消"
                                                                destructiveButtonTitle:nil
                                                                otherButtonTitles:@"拍照", @"相册中选择",nil];
    [actionSheet showInView:self];
   actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    //    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"想选择图片来源" message:@"选择一个图片source" preferredStyle:UIAlertControllerStyleActionSheet];
    //    UIAlertAction *imageAlume = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //打开相册
    //        [self openAlume];
    //    }];
    //    [alertVc addAction:imageAlume];
    //
    //    UIAlertAction *takePhoes = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //打开相册
    //        [self openAlume];
    //    }];
    //    [alertVc addAction:takePhoes];
    //    [self makeSureDelegateFun];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != 2) {
        
        if ([self.delegate respondsToSelector:@selector(editPhotoViewToOpenAblum:pickerType:)]) {
            [self.delegate editPhotoViewToOpenAblum:self pickerType:buttonIndex];
        }
    }
    
    
}


-(void)makeSureDelegateFun:(NSInteger)pickerType{
    
    if ([self.delegate respondsToSelector:@selector(editPhotoViewToOpenAblum:pickerType:)]) {
        [self.delegate editPhotoViewToOpenAblum:self pickerType:pickerType];
    }
    
    
    //    if ([self.delegate respondsToSelector:@selector(editPhotoViewToOpenAblum:)]) {
    //        [self.delegate editPhotoViewToOpenAblum:self];
    //    }
}

//布局
-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat labX = 15;
    CGFloat labY = 5;
    CGFloat labW = 250;
    CGFloat labH = 15;
    self.noticeLab.frame = CGRectMake(labX, labY, labW, labH);
    
    //设置button的frame
    CGFloat buttonW = kImageViewWidth;
    CGFloat buttonH = buttonW;
    for (int i = 1; i < self.subviews.count; ++ i) {
        UIButton *sub = self.subviews[i];
        sub.tag = 45 + i;//从46开始
        if ([sub isKindOfClass:[UIButton class]]) {
            CGFloat currentRow = (i-1)/kMaxColumn;
            NSInteger currentCol = (i-1)%kMaxColumn;
            CGFloat buttonX = currentCol * (buttonW + pMargin) + pMargin;
            CGFloat buttonY = currentRow *(buttonW + pMargin) + pMargin + labH + labY;//第一个icon的y值离noticLab 的高度是kMargin
            sub.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
        sub.contentMode = UIViewContentModeCenter;
        [sub setImage:self.photoes[i-1] forState:UIControlStateNormal];
    }
    //判断自己的view的高度
    NSInteger currentRow = (self.photoes.count - 1)/3 + 1;//至少有一行
    [self setHeight:currentRow *(buttonW + pMargin) + pMargin + labH + labY];
}

-(void)addOneImage:(UIImage *)image{
    [self.photoes insertObject:image atIndex:(self.photoes.count - 1)];
    //在button上添加一个删除按钮
    THRemoveButton *button = [[THRemoveButton alloc]init];
    [self insertSubview:button atIndex:(self.subviews.count - 1)];
    //判断照片的数量，如果10张，我们就删除“+”
    if (self.photoes.count == 7) {
        [self.photoes removeLastObject];
        [self.addBtn removeFromSuperview];

        
    }
    [self updateNoticeText];
    [self setNeedsLayout];
}
//更新noticeLab的文字
- (void)updateNoticeText{
    NSInteger picCount = [self fetchPhotos].count;
    self.noticeLab.text = [NSString stringWithFormat:@"为了照片质量，请有限制发图数量(0/6)",picCount];
}
#pragma 获取图片数组
-(NSMutableArray *)fetchPhotos{
    //判断self.addBtn 是否在view中，用来确定是否返回
    if ([self.subviews containsObject:self.addBtn]) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.photoes];
        [temp removeLastObject];
        return temp;
    }else{
        return self.photoes;
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}



@end
