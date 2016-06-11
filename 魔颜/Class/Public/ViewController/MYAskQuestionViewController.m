//
//  MYAskQuestionViewController.m
//  魔颜
//
//  Created by Meiyue on 16/5/11.
//  Copyright © 2016年 abc. All rights reserved.
//

#import "MYAskQuestionViewController.h"
#import "MYTextView.h"
#import "THEditPhotoView.h"
#import "UITextField+Extension.h"
#import "UIAlertViewTool.h"
#import "LQImgPickerActionSheet.h"
#import "LQPhotoPickerViewController.h"
#import "MYQuestionViewController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#import "NSString+Extension.h"
@interface MYAskQuestionViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,THEditPhotoViewDelegate,UITextViewDelegate,UITextFieldDelegate,LQPhotoPickerViewDelegate>

/** 标题 */
@property (weak, nonatomic) UITextField *textFiele;

/** 文字 */
@property (strong, nonatomic) MYTextView *textView;

/** 图片 */
@property(weak,nonatomic) THEditPhotoView *editPhotoView;

@property(strong,nonatomic) NSMutableArray * requestImageArr;

@property(strong,nonatomic) NSString * picArrstr;

/** 发布按钮 */
@property (weak, nonatomic) UIButton *publicBtn;

@property(assign,nonatomic) BOOL  isPulic;

@end

@implementation MYAskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(cancel) image:@"back-1" highImage:@"back-1"];
    
    self.requestImageArr = [NSMutableArray array];
     
    
    /**
     *  依次设置
     */
    self.LQPhotoPicker_superView = self.view;
    
    self.LQPhotoPicker_imgMaxCount = 6;
    
    NSMutableArray *imagearr0 = [[NSMutableArray alloc]init];
    NSArray *contentimagearr = [MYUserDefaults objectForKey:@"requestimagearr"];
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
    
    self.LQPhotoPicker_delegate     = self;
    
    //初始化界面
    [self setupUI];
 
    [self.textFiele becomeFirstResponder];
}

- (void)cancel
{
    
    [self.textView resignFirstResponder];
    [self.textFiele resignFirstResponder];
    

      
        [self requestimagearr];
        
        if ((self.textView.text==nil||[self.textView.text isEqualToString:@""])&&(self.textFiele.text==nil|| [self.textFiele.text isEqualToString:@""])&&(self.picArrstr==nil||[self.picArrstr isEqualToString:@""])) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [UIAlertViewTool showAlertView:self title:nil message:@"保存信息？" cancelTitle:@"不保存" otherTitle:@"保存" cancelBlock:^{
                
                [MYUserDefaults setObject:nil forKey:@"requestimagearr"];
                [MYUserDefaults setObject:nil forKey:@"requesttitle"];
                [MYUserDefaults setObject:nil forKey:@"requestcontent"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            } confrimBlock:^{
             
                if ((self.textFiele.text==nil|| self.textView.text==nil)&&self.requestImageArr.count!=0) {
                    
                    }else{
                    
                    [MYUserDefaults setObject:self.textFiele.text forKey:@"requesttitle"];
                    [MYUserDefaults setObject:self.textView.text forKey:@"requestcontent"];
                    [MYUserDefaults setObject:self.requestImageArr forKey:@"requestimagearr"];
                }
                
                 [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
    
    

    
    
}
//初始化界面
- (void)setupUI
{
    self.title = @"提问";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //上面一根线
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MYScreenW, 0.5)];
    topLineView.alpha = 0.4;
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topLineView];
    
    //标题
    UILabel *label = [UILabel addLabelWithFrame:CGRectMake(15, topLineView.bottom, 100, 40) title:@"标题" titleColor:titlecolor font:ThemeFont];
    [self.view  addSubview:label];
    
    UITextField *textFiele = [UITextField addFieldWithFrame:CGRectMake(label.right + 5, label.y, MYScreenW - label.right - kMargin, label.height) text:nil font:ThemeFont placeholder:@"请添加您的标题"];
    textFiele.delegate =self;
    textFiele.textAlignment = NSTextAlignmentLeft;
    self.textFiele = textFiele;
    [self.view addSubview:textFiele];
    textFiele.font = MYFont(14);
    textFiele.textColor = titlecolor;
    NSString *titlestr=[MYUserDefaults objectForKey:@"requesttitle"];
    self.textFiele.text = titlestr;
    
    
    //下面一根线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, MYScreenW, 0.5)];
        bottomLineView.alpha = 0.4;
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomLineView];
    
    //文本输入栏
    MYTextView *textView = [[MYTextView alloc] initWithFrame:CGRectMake(kMargin, bottomLineView.bottom, MYScreenW - MYMargin, 120)];
    textView.textColor = titlecolor;
    textView.delegate = self;
    textView.font = MYFont(14);
    [self.view addSubview:textView];
    self.textView = textView;
    NSString *textviewstr = [MYUserDefaults objectForKey:@"requestcontent"];
    if (textviewstr==nil ||[textviewstr isEqualToString:@""]) {
        textView.placeHoledr = @"若您有美容、护肤、微整形等方面的困扰可在这里提问，我们准备了各种专家为您解答。";
    }else{
        textView.text = textviewstr;
    }

    
    //photoPicker
    [self LQPhotoPicker_updatePickerViewFrameY:CGRectGetMaxY(textView.frame)+kMargin];
       
    
    //发布按钮
    UIButton *public = [[UIButton alloc]initWithFrame:CGRectMake(kMargin, self.view.height-120, MYScreenW-MYMargin, 40)];
    [public setTitle:@"确认发布" forState:UIControlStateNormal];
    public.backgroundColor = UIColorFromRGB(0xed0282);
    [public setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    public.titleLabel.font = MYSFont(15);
    public.layer.cornerRadius = 5;
    public.layer.masksToBounds = YES;
    [public addTarget:self action:@selector(pushNextVC2) forControlEvents:UIControlEventTouchUpInside];
    self.publicBtn = public;
    [self.view addSubview:public];
    self.isPulic = YES;
    
}


- (void)pushNextVC2
{
    if (!self.isPulic) {
        
    }else{
    
        if ( NULLString(self.textFiele.text)|| NULLString(self.textView.text)) {
            [MBProgressHUD showHUDWithTitle:@"标题和内容都不能为空" andImage:nil andTime:1.0];
            return;
        }else{

            if ([NSString stringContainsEmoji:self.textFiele.text]||[NSString stringContainsEmoji:self.textView.text]) {
                [MBProgressHUD showHUDWithTitle:@"暂不支持表情" andImage:nil andTime:1.0];
                return;
            }else{
                [MBProgressHUD showMessage:@"上传数据中，请稍候..."];
                //先将未到时间执行前的任务取消。
                [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoPulick) object:nil];
                [self performSelector:@selector(gotoPulick)withObject:nil afterDelay:0.2f];
            }
        
        }
    }
    
    
}
//发布
- (void)gotoPulick
{
        self.isPulic = NO;
    
        [self requestimagearr];
          
        if (self.picArrstr ==nil) {
            NSMutableArray *imageArr = [NSMutableArray array];
            NSArray *contentarr = [MYUserDefaults objectForKey:@"requestimagearr"];
            for (int i=0; i<contentarr.count; i++) {
                
                NSString *str = [contentarr[i] base64EncodedStringWithOptions:0];
                [imageArr addObject:str];
            }
            self.picArrstr = [imageArr componentsJoinedByString:@","];

        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"comment"] = self.textView.text;
        params[@"userid"] = [MYUserDefaults objectForKey:@"id"];
        params[@"commentPic"] = self.picArrstr;
        params[@"title"] = self.textFiele.text;
        params[@"classify"] = @(0);
        params[@"type"] = @(1);
        
        
        [MYHttpTool postWithUrl:[NSString stringWithFormat:@"%@publish/addPublish",kOuternet1] params:params success:^(id responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
                [MBProgressHUD showHUDWithTitle:@"发帖成功" andImage:nil andTime:1.0];
                
                [MYUserDefaults setObject:nil forKey:@"requesttitle"];
                [MYUserDefaults setObject:nil forKey:@"requestcontent"];
                [MYUserDefaults setObject:nil forKey:@"requestimagearr"];

                MYQuestionViewController *questVC = [[MYQuestionViewController alloc]init];
                questVC.id = responseObject[@"publishId"];
                [self.navigationController pushViewController:questVC animated:YES];
                [MBProgressHUD hideHUD];

            }else if([responseObject[@"status"] isEqualToString:@"-110"]){
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"暂不支持表情"];
            }else
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"发帖失败"];
            }
             [MBProgressHUD hideHUD];
            self.isPulic = YES;
         } failure:^(NSError *error) {
             
             [MBProgressHUD hideHUD];
             [MBProgressHUD showError:@"发帖失败"];
             
             self.isPulic = YES;
         }];
    
}

-(void)requestimagearr
{
    
    NSMutableArray *imageArr = [NSMutableArray array];
   self.requestImageArr = [NSMutableArray array];
    //大图数组
    NSMutableArray *bigImageArray = [self LQPhotoPicker_getBigImageArray];
    
    for (UIImage *picImage in bigImageArray) {
        
        NSData *imageData = UIImageJPEGRepresentation(picImage, 0.5);
        
        [self.requestImageArr addObject:imageData];
        
        NSString *str = [imageData base64EncodedStringWithOptions:0];
        [imageArr addObject:str];
        
    }
    
    self.picArrstr = [imageArr componentsJoinedByString:@","];
    

}
#pragma mark - 各种代理方法
-(void)editPhotoViewToOpenAblum:(THEditPhotoView *)editView pickerType:(NSInteger)pickerType{
    
    UIImagePickerController *pickView = [[UIImagePickerController alloc]init];
    pickView.delegate = self;
    pickView.allowsEditing = YES;
    if (pickerType == 0) {
        
        pickView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }else{
        
        if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
            
            [MBProgressHUD showError:@"模拟器无法打开相机"];
            return;
        }
    
        pickView.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self presentViewController:pickView animated:YES completion:nil];
}

//点击图片成功
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    
    [self.editPhotoView addOneImage:image];
    
    [self requestimagearr];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击pickerview的取消，不加图片了
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
//    
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textFiele resignFirstResponder];
    
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual:_textView])
    {
        
    }else{
        
        [self.view endEditing:YES];
    }
}

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
    [_textView setInputAccessoryView:topView];
    
    return YES;
}
//隐藏键盘
- (void)resignKeyboard {
    
    [_textView resignFirstResponder];
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

@end
