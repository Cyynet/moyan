//
//  MYMYRandomChatPublicViewController.m
//  魔颜
//
//  Created by abc on 16/5/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYRandomChatPublicViewController.h"
#import "MYTextView.h"
#import "UILabel+Extension.h"
#import "THEditPhotoView.h"
#import "NSString+Extension.h"
#import "UIAlertViewTool.h"
#import "LQPhotoPickerViewController.h"
#import "MYBeautyViewController.h"
#import "MYArticleViewController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#import "UITextField+Extension.h"

@interface MYRandomChatPublicViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,THEditPhotoViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,LQPhotoPickerViewDelegate,UITextFieldDelegate>

@property(strong,nonatomic) UIScrollView * scrollview;

/** 标题 */
@property (weak, nonatomic) UITextField *textFiele;

@property(strong,nonatomic) UIImageView * headerimage;
@property(strong,nonatomic) MYTextView * contenview;
@property(strong,nonatomic) THEditPhotoView * editPhotoView;
@property(strong,nonatomic) THEditPhotoView * editPhotoView1;

@property(strong,nonatomic) NSString * headerimagestr;
@property(strong,nonatomic) NSString * contentimagestr;

@property(assign,nonatomic) NSInteger  imagetype;
@property(strong,nonatomic) NSString * headerimagebool;


@property(strong,nonatomic) NSData * headerimagedata;
@property(strong,nonatomic) NSMutableArray * contenimagedataArr;
@property(strong,nonatomic) UIButton * swichimage;
@property(strong,nonatomic) UIButton * public;

@property(assign,nonatomic) BOOL  isPulic;

@end

@implementation MYRandomChatPublicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
    
//    if (![MYUserDefaults objectForKey:@""]&&![MYUserDefaults objectForKey:@""]&&![MYUserDefaults objectForKey:@""]) {
//        self.headerimage.image =[UIImage imageNamed:@"xuxian@2x(1)"];
//        self.titleview.placeHoledr = @"标题";
//        self.contenview.placeHoledr = @"晒一晒您的美容心得或是您心仪的美容院也或是您的美妆技巧，也可以是服装搭配，来晒一晒您关于美的一切吧～";
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"随便聊聊";
    
    [self addscrollview];
    [self addheaderimage];
    [self addtextview];
    [self addboomview];
    
    [self.textFiele becomeFirstResponder];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancel) image:@"back-1" highImage:@"back-1"];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 64, MYScreenW, 0.5)];
    lineview.backgroundColor = [UIColor lightGrayColor];
    lineview.alpha = 0.4;
    [self.view addSubview:lineview];
    
    
    UIButton *switchimage = [[UIButton alloc]initWithFrame:CGRectMake(MYScreenW-kMargin-50-27, 217-15, 18+50, 15)];
    //    switchimage.image = [UIImage imageWithName:@"SwitchHeaderimage"];
    [switchimage setImage:[UIImage imageNamed:@"SwitchHeaderimage"] forState:UIControlStateNormal];
    [switchimage setTitle:@"切换封面" forState:UIControlStateNormal];
    switchimage.titleLabel.font = MYFont(13);
    self.swichimage.hidden = YES;
    self.swichimage = switchimage;
    [self.headerimage addSubview:switchimage];
    [self.headerimage bringSubviewToFront:switchimage];
    
    
    
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = self.scrollview;
    
    self.LQPhotoPicker_imgMaxCount = 6;
    
    NSMutableArray *imagearr0 = [[NSMutableArray alloc]init];
    NSArray *contentimagearr = [MYUserDefaults objectForKey:@"contimagestr"];
    if (contentimagearr.count) {
        
        for (int i=0; i<contentimagearr.count; i++) {
            UIImage *image = [UIImage imageWithData:contentimagearr[i]];
            
            [imagearr0 addObject:image];
        }
    }
    
    if (imagearr0.count) {
        
        [self LQPhotoPicker_initPickerView:imagearr0 imagedata:contentimagearr];
        
    }else{
        [self LQPhotoPicker_initPickerView:nil imagedata:nil];
    }
    
    
    self.LQPhotoPicker_delegate = self;
}
//返回
- (void)cancel
{
    [self.textFiele resignFirstResponder];
    [self.contenview resignFirstResponder];
    

        [self checkoutImageData];
        
        if (self.headerimagestr ==nil &&(self.contentimagestr == nil||[self.contentimagestr isEqualToString:@""])&& (self.textFiele.text == nil || [self.textFiele.text isEqualToString:@""]) && (self.contenview.text ==nil ||[self.contenview.text isEqualToString:@""]))
        {
            
             [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            

            [UIAlertViewTool showAlertView:self title:nil message:@"保存信息？" cancelTitle:@"不保存" otherTitle:@"保存" cancelBlock:^{
                
                [MYUserDefaults setObject:nil forKey:@"title"];
                [MYUserDefaults setObject:nil forKey:@"contentext"];
                [MYUserDefaults setObject:nil forKey:@"headerimagestr"];
                [MYUserDefaults setObject:nil forKey:@"contimagestr"];
                
                  [self.navigationController popViewControllerAnimated:YES];
                
                
            } confrimBlock:^{
                
                NSData *headerdata0 = [MYUserDefaults objectForKey:@"headerimagestr"];
                if ((self.textFiele.text==nil||self.contenview.text==nil)&& self.contenimagedataArr.count!=0) {
                    
                }else{
                    [MYUserDefaults setObject:self.textFiele.text forKey:@"title"];
                    [MYUserDefaults setObject:self.contenview.text forKey:@"contentext"];
                    
                    [MYUserDefaults setObject:self.contenimagedataArr forKey:@"contimagestr"];
                }
                
                if (headerdata0==nil) {
                    [MYUserDefaults setObject:self.headerimagedata forKey:@"headerimagestr"];
                }else{
                    
                }
                 [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        }
    
}

#pragma mark--添加scrollview
-(void)addscrollview
{
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, MYScreenW,MYScreenH-1)];
    [self.view addSubview:scrollview];
    scrollview.delegate = self;
    scrollview.bounces = YES;
    scrollview.showsVerticalScrollIndicator = NO;
    CGFloat height;
    if(MYScreenW<=320){
        height =150;
    }else{
        height = 100;
    }
    scrollview.contentSize = CGSizeMake(1, MYScreenH+height);
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    
}
#pragma mark-- 添加封面视图
-(void)addheaderimage
{
    
    UIButton *headerbtn = [[UIButton alloc]initWithFrame:CGRectMake((MYScreenW-MYMargin-80)/2, kMargin+(217-40)/2, 80, 40)];
    [self.scrollview addSubview:headerbtn];
    [headerbtn setTitle:@"添加封面" forState:UIControlStateNormal];
    [headerbtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
    headerbtn.titleLabel.font = MYFont(14);
    [headerbtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    headerbtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    
    
    UIImageView *headerimage = [[UIImageView alloc]initWithFrame:CGRectMake(kMargin, kMargin, MYScreenW-MYMargin, 217)];
    [self.scrollview addSubview:headerimage];
    headerimage.userInteractionEnabled = YES;
    self.headerimage = headerimage;
    NSData *headerimage0 = [MYUserDefaults objectForKey:@"headerimagestr"];
    
    if (headerimage0) {
        headerimage.image = [UIImage imageWithData:headerimage0];
        self.swichimage.hidden = NO;
        
    }else{
        headerimage.image = [UIImage imageNamed:@"xuxian@2x(1)"];
    }
    
    
    
    
    UITapGestureRecognizer* tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHeaderimage:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate= self;
    [headerimage addGestureRecognizer:tap];
    
    
}
-(void)addtextview
{
    
    //标题
    UILabel *label = [UILabel addLabelWithFrame:CGRectMake(15, self.headerimage.bottom+25, 100, 40) title:@"标题" titleColor:titlecolor font:ThemeFont];
    [self.scrollview  addSubview:label];
    
    UITextField *textFiele = [UITextField addFieldWithFrame:CGRectMake(label.right + 5, label.y, MYScreenW - label.right - kMargin, label.height) text:nil font:ThemeFont placeholder:@"请添加您的标题"];
    textFiele.delegate =self;
    textFiele.textAlignment = NSTextAlignmentLeft;
    self.textFiele = textFiele;
    [self.scrollview addSubview:textFiele];
    textFiele.font = MYFont(14);
    textFiele.textColor = titlecolor;
    NSString *titlestr=[MYUserDefaults objectForKey:@"requesttitle"];
    self.textFiele.text = titlestr;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kMargin, label.bottom, MYScreenW-MYMargin, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.4;
    [self.scrollview addSubview:line];
    
    
    MYTextView *contenview = [[MYTextView alloc]initWithFrame:CGRectMake(kMargin, label.bottom+kMargin, MYScreenW-MYMargin, 100)];
//     contenview.layoutManager.allowsNonContiguousLayout=NO;
    self.contenview = contenview;
    contenview.placeLabel.font = MYFont(14);
    contenview.tag = 2;
    contenview.font = MYFont(14);
    contenview.delegate= self;
    [self.scrollview addSubview:contenview];
    NSString *contentstr = [MYUserDefaults objectForKey:@"contentext"];
    if (contentstr !=nil&& ![contentstr isEqualToString:@""]) {
        
        contenview.text = contentstr;
    }else{
        contenview.placeHoledr = @"晒一晒您的美容心得或是您心仪的美容院也或是您的美妆技巧，也可以是服装搭配，来晒一晒您关于美的一切吧～";
    }

    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:CGRectGetMaxY(contenview.frame)+kMargin];

    
    
}
-(void)addboomview
{
    
    UIView *boomview = [[UIView alloc]initWithFrame:CGRectMake(0, MYScreenH-65, MYScreenW, 65)];
    [self.view addSubview:boomview];
    boomview.backgroundColor = [UIColor whiteColor];
    
    UIButton *public = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, 10, MYScreenW-MYMargin, 40)];
    [boomview addSubview:public];
    [public setTitle:@"确认发布" forState:UIControlStateNormal];
    public.backgroundColor = UIColorFromRGB(0xed0282);
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    public.titleLabel.font = MYSFont(15);
    public.layer.cornerRadius = 5;
    public.layer.masksToBounds = YES;
    [public addTarget:self action:@selector(pushNextVC1) forControlEvents:UIControlEventTouchUpInside];
    self.public = public;
    self.isPulic = YES;
}

#pragma mark - 各种代理方法
-(void)editPhotoViewToOpenAblum:(THEditPhotoView*)editView pickerType:(NSInteger)pickerType{
    
    UIImagePickerController *pickView = [[UIImagePickerController alloc]init];
    pickView.delegate = self;
    pickView.allowsEditing = YES;
    
    if (pickerType == 1) {
        
        pickView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickView.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    
    pickView.allowsEditing = YES;
    [self presentViewController:pickView animated:YES completion:nil];
}

//点击图片成功
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    
    if (self.imagetype==1) {
        
        if (image!=nil) {
            self.headerimage.image=nil;
            self.headerimage.contentMode = UIViewContentModeScaleAspectFill;
            self.headerimage.clipsToBounds = YES;
            self.headerimage.image = image;
            self.imagetype = 0;
            self.headerimagebool = @"yes";
            NSData *imageData = UIImageJPEGRepresentation(self.headerimage.image, 0.0001);
            self.headerimagedata = imageData;
            self.headerimagestr = [imageData base64EncodedStringWithOptions:0];
            self.swichimage.hidden = NO;
            [MYUserDefaults setObject:self.headerimagedata forKey:@"headerimagestr"];
        }else{
            
        }
    }else{
        
        [self.editPhotoView addOneImage:image];

    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击pickerview的取消，不加图片了
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)pushNextVC1
{
    if (!self.isPulic) {
        
        
    }else{
        
         NSData *headerdata00 = [MYUserDefaults objectForKey:@"headerimagestr"];
        if (NULLString(self.textFiele.text) || NULLString(self.contenview.text)) {
            [MBProgressHUD showHUDWithTitle:@"标题和内容都不能为空" andImage:nil andTime:1.0];
            return;
        }else if ([NSString stringContainsEmoji:self.textFiele.text]||[NSString stringContainsEmoji:self.contenview.text]) {
            [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
            return;
            
        }else if (![self.headerimagebool isEqual:@"yes"]&& headerdata00==nil) {
            [MBProgressHUD showHUDWithTitle:@"封面图片不能为空" andImage:nil andTime:1.0];
            return;
        }else{

            [MBProgressHUD showMessage:@"上传数据中，请稍候..."];
            //先将未到时间执行前的任务取消。
            [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoPulick) object:nil];
            [self performSelector:@selector(gotoPulick)withObject:nil afterDelay:0.2f];
        }

    }
}

//提交后台数据
-(void)gotoPulick
{
        self.isPulic = NO;
    
        [self checkoutImageData];
    
       NSData *headerdata00 = [MYUserDefaults objectForKey:@"headerimagestr"];
        
        if (self.headerimagestr==nil) {
            
            self.headerimagestr = [headerdata00 base64EncodedStringWithOptions:0];
        }
        if (self.contentimagestr ==nil) {
            
            NSMutableArray *imageArr = [NSMutableArray array];
            NSArray *contentarr = [MYUserDefaults objectForKey:@"contimagestr"];
            for (int i=0; i<contentarr.count; i++) {
                
                NSString *str = [contentarr[i] base64EncodedStringWithOptions:0];
                [imageArr addObject:str];
            }
            self.contentimagestr = [imageArr componentsJoinedByString:@","];
        }
        

        
//        NSString *titlestr = [NSString utf8ToUnicode:self.titleview.text];
//        NSString *contenstr = [NSString utf8ToUnicode:self.contenview.text];
        
    
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"comment"] = self.contenview.text;                   //发布内容
            param[@"commentPic"] = self.contentimagestr;                       //发布图片
            param[@"userid"] = [MYUserDefaults objectForKey:@"id"];;          //用户
            param[@"type"] = @"0";                                      //发布类型
            param[@"homePic"] = self.headerimagestr;                     //外部展示图
            param[@"title"] = self.textFiele.text;                      //发布标题
            param[@"classify"] = @"0";
            
    
            [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@/publish/addPublish",kOuternet1] params:param success:^(id responseObject) {
                
                if ([responseObject[@"status"] isEqualToString:@"success"]) {
                    
                    [MBProgressHUD showHUDWithTitle:@"发布成功" andImage:nil andTime:1.0];
                    
                    [MYUserDefaults setObject:nil forKey:@"title"];
                    [MYUserDefaults setObject:nil forKey:@"contentext"];
                    [MYUserDefaults setObject:nil forKey:@"contimagestr"];

                    MYArticleViewController *randomchatVC = [[MYArticleViewController alloc]init];
                    randomchatVC.id = responseObject[@"publishId"];
                    
                    if (!self.headerimagedata) {
                        self.headerimagedata = [MYUserDefaults objectForKey:@"headerimagestr"];
                    }
                    randomchatVC.headimagedata = self.headerimagedata;
                    
                    randomchatVC.TYpe =@"pul";
                    [self.navigationController pushViewController:randomchatVC animated:YES];

                    [MBProgressHUD hideHUD];
                    
                     [MYUserDefaults setObject:nil forKey:@"headerimagestr"];

                }else if([responseObject[@"status"] isEqualToString:@"-110"]){

                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"暂不支持表情"];
                }else{
                         [MBProgressHUD showError:@"发布失败"];
                }
                self.isPulic = YES;
            } failure:^(NSError *error) {
                [MBProgressHUD showError:@"发布失败"];
                [MBProgressHUD hideHUD];
                self.isPulic = YES;
                
            }];
    
    
}

-(void)checkoutImageData
{
    NSMutableArray *imageArr = [NSMutableArray array];
    self.contenimagedataArr = [NSMutableArray array];
    //大图数组
    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    
    for (UIImage *picImage in bigImageArray) {
        
        NSData *imageData = UIImageJPEGRepresentation(picImage, 0.5);
        
        [self.contenimagedataArr addObject:imageData];
        
        NSString *str = [imageData base64EncodedStringWithOptions:0];
        [imageArr addObject:str];
        
    }
    
    self.contentimagestr = [imageArr componentsJoinedByString:@","];
    
    
}

//手势方法
-(void)clickHeaderimage:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
    self.imagetype =1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"相册中选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex != 2) {
        
        [self editPhotoViewToOpenAblum:self.editPhotoView pickerType:buttonIndex];
    }
    
    
    
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if([scrollView isEqual:_contenview])
//    {
//        
//    }else{
//        
//        [self.view endEditing:YES];
//    }
//}



-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil]; [topView setItems:buttonsArray];
    [_contenview setInputAccessoryView:topView];

    return YES;
}

/**
 *  IOS键盘出现时视图上移
 *
 */
- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    [self animateTextField: textView up: YES];
   
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self animateTextField: textView up: NO];
    return YES;
}

- (void) animateTextField: (UITextView*) textField up: (BOOL) up
{
    if (textField.tag && self.scrollview.contentOffset.y < 110) {
        
        const int movementDistance = 80; // tweak as needed
        
        [UIView animateWithDuration:0.3f animations:^{
            
            int movement = (up ? -movementDistance : movementDistance);
            
            self.scrollview.frame = CGRectOffset(self.scrollview.frame, 0, movement);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    //    textview 改变字体的行间距
        // 判断是否有候选字符，如果不为nil，代表有候选字符
        if(textView.markedTextRange == nil){
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 2; // 字体的行间距
            paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
        }
    
}

//隐藏键盘
- (void)resignKeyboard {
    
    [_contenview resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFiele resignFirstResponder];
    
    return YES;
}

/**
 *  UITextView没有像UITextField中textFieldShouldReturn:这样的方法，那么要实现UITextView return键隐藏键盘，可以通过判断输入的字符是不是回车符来实现。
 */
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
@end
