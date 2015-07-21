//
//  ViewController.m
//  DemoSubmit-0717
//
//  Created by 徐臻 on 15/7/17.
//  Copyright (c) 2015年 徐臻. All rights reserved.
//

#import "ViewController.h"
#import "PDDropDownList.h"

/**自定义颜色*/
#define RHColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255/255.0]

/**是否iPhone6以上 */
#define is4_7InchPlus   ([UIScreen mainScreen].bounds.size.height >= 667.0)
//label Width
#define LabelWidth (is4_7InchPlus?120:80)

#define TextFieldWidth (is4_7InchPlus?200:160)

#define SpaceWidth (is4_7InchPlus?65:40)

#define LeftSpaceWidth (is4_7InchPlus?25:15)


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)PDDropDownList *payView;

@property (nonatomic ,strong)PDDropDownList *bankView;



@property (nonatomic ,assign) bool isOpen;

@property (nonatomic ,strong) NSMutableArray *payArray;
@property (nonatomic ,strong) NSMutableArray *bankArray;

@property (nonatomic ,strong) PDListTableView *listTableView;

@property (nonatomic ,strong) PDListTableView *ristTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RHColor(245, 245, 245);

    [self initUI];
    [self initTableView];
}

- (void)initUI
{
    //
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth * 3, 64 + SpaceWidth, LabelWidth, 44)];
    tips.text = @"充值币种：人民币";
    tips.font = [UIFont systemFontOfSize:14];
    tips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tips];
    
    //
    UILabel *realName = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth, 64 + SpaceWidth * 2, LabelWidth, 44)];
    UITextField *realField = [[UITextField alloc]init];
    
    [self setAllUILabel:realName andAttributedString:@"*汇款人真实姓名:" andTextView:realField andPlaceholder:@"请输入线下汇款持卡人姓名"];
    //
    UILabel *money = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth, 64 + SpaceWidth * 3, LabelWidth, 44)];
    UITextField *moneyField = [[UITextField alloc]init];
    [self setAllUILabel:money andAttributedString:@"*汇款金额:" andTextView:moneyField andPlaceholder:@"请输入充值金额,支持2位小数"];

    //
    UILabel *channel = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth, 64 + SpaceWidth * 4, LabelWidth, 44)];
    
    [self setAllUILabel:channel andAttributedString:@"*汇款渠道:" andTextView:self.payView andPlaceholder:nil];

    //
    UILabel *bank = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth, 64 + SpaceWidth * 5, LabelWidth, 44)];
//    UITextField *bankField = [[UITextField alloc]init];
    [self setAllUILabel:bank andAttributedString:@"*银行名称:" andTextView:self.bankView andPlaceholder:nil];

    //
    UILabel *account = [[UILabel alloc]initWithFrame:CGRectMake(LeftSpaceWidth, 64 + SpaceWidth * 6, LabelWidth, 44)];
    UITextField *accountField = [[UITextField alloc]init];
    [self setAllUILabel:account andAttributedString:@"*汇款账号:" andTextView:accountField andPlaceholder:@"请输入汇款的银行卡卡号"];
    
    
}

//设置label和textField
- (void)setAllUILabel:(UILabel *)pdLabel andAttributedString:(NSString *)attributedString andTextView:(UIView *)tf andPlaceholder:(NSString *)placeHolder
{
    pdLabel.font = [UIFont systemFontOfSize:15];
    pdLabel.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    pdLabel.attributedText = str;
    
    //
    CGRect frame = pdLabel.frame;
    frame.origin.x = CGRectGetMaxX(pdLabel.frame) + 10;
    frame.size.width = TextFieldWidth;
    frame.size.height = 40;
    if ([tf isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)tf;
        textField.frame = frame;
        textField.placeholder = placeHolder;
        textField.font = [UIFont systemFontOfSize:14];
        textField.backgroundColor = [UIColor whiteColor];
        //设置边框样式，只有设置了才会显示边框样式
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
    }else
    {
        PDDropDownList *pd = (PDDropDownList *)tf;
        pd.frame = frame;
        pd.titleLabel.frame  = CGRectMake(10, 0, pd.frame.size.width/2, pd.frame.size.height);
        pd.thirdView.frame  = CGRectMake(10, 0, pd.frame.size.width, pd.frame.size.height);
        pd.imageView.frame = CGRectMake(pd.frame.size.width - 30, 10, 20, 20);

        pd.thirdView.hidden = YES;
//        pd.imageView.hidden = YES;
        [self.view addSubview:pd];
    }
   
    [self.view addSubview:pdLabel];
    
}

- (void)initTableView
{
//    self.payView.frame = CGRectMake(100, 100, 200, 44);
//    self.payView.titleLabel.frame  = CGRectMake(10, 0, self.payView.frame.size.width/2, self.payView.frame.size.height);
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.view addSubview:self.listTableView];
    self.listTableView.hidden = !self.isOpen;
    
    self.ristTableView.dataSource = self;
    self.ristTableView.delegate = self;
    [self.view addSubview:self.ristTableView];
    self.ristTableView.hidden = !self.isOpen;
    
    __weak typeof(self) weakSelf = self;
    self.payView.operation = ^(){
        CGRect frame = weakSelf.payView.frame;
        frame.size.height = 80;
        frame.origin.y = weakSelf.payView.frame.origin.y + self.payView.frame.size.height;
        weakSelf.listTableView.frame = frame;
        
        weakSelf.listTableView.hidden = !weakSelf.listTableView.hidden;
        weakSelf.ristTableView.hidden = YES;
    };
    
    //第二个
//    self.bankView.frame = CGRectMake(100, 300, 200, 44);
//    _bankView.titleLabel.frame  = CGRectMake(10, 0, self.bankView.frame.size.width/2, self.bankView.frame.size.height);
//    _bankView.thirdView.frame  = CGRectMake(10, 0, self.bankView.frame.size.width, self.bankView.frame.size.height);
//    _bankView.thirdView.hidden = YES;
    
    
    self.bankView.operation = ^(){
        
        CGRect frame = weakSelf.bankView.frame;
        frame.size.height = 120;
        frame.origin.y = weakSelf.bankView.frame.origin.y + self.bankView.frame.size.height;
        weakSelf.ristTableView.frame = frame;
        
        weakSelf.ristTableView.hidden = !weakSelf.ristTableView.hidden;
        weakSelf.listTableView.hidden = YES;
    };
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.listTableView) {
        return self.payArray.count;
    }else
    {
        return self.bankArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (tableView == self.listTableView) {
        cell.textLabel.text = self.payArray[indexPath.row];
    }else
    {
        cell.textLabel.text = self.bankArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.listTableView)
    {
        self.payView.titleLabel.text = self.payArray[indexPath.row];
        self.listTableView.hidden = YES;
        if ([self.payView.titleLabel.text isEqualToString:@"第三方支付"])
        {
            self.bankView.titleLabel.hidden = YES;
            self.bankView.thirdView.hidden = NO;
            self.bankView.imageView.hidden = YES;
        }else
        {
            self.bankView.titleLabel.hidden = NO;
            self.bankView.thirdView.hidden = YES;
            self.bankView.imageView.hidden = NO;
        }
    }else
    {
        self.bankView.titleLabel.text = self.bankArray[indexPath.row];
        self.ristTableView.hidden = YES;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - 懒加载
-(UITableView *)listTableView{
    if(!_listTableView)
    {
        _listTableView = [[PDListTableView alloc]init];
    }
    return _listTableView;
}
-(UITableView *)ristTableView{
    if(!_ristTableView)
    {
        _ristTableView = [[PDListTableView alloc]init];
    }
    return _ristTableView;
}

- (PDDropDownList *)payView
{
    if (!_payView) {
        _payView = [[PDDropDownList alloc]init];
        _payView.userInteractionEnabled = YES;
        _payView.titleLabel.text = @"银行";
        [self.view addSubview:_payView];
    }
    return _payView;
}

- (PDDropDownList *)bankView
{
    if (!_bankView) {
        _bankView = [[PDDropDownList alloc]init];
        _bankView.userInteractionEnabled = YES;
        _bankView.titleLabel.text = @"中国银行";
        [self.view addSubview:_bankView];
    }
    return _bankView;
}
- (NSMutableArray *)payArray
{
    if (!_payArray) {
        _payArray = [[NSMutableArray alloc]initWithObjects:@"银行",@"第三方支付", nil];
    }
    return _payArray;
}
- (NSMutableArray *)bankArray
{
    if (!_bankArray) {
        _bankArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4", nil];
    }
    return _bankArray;
}

@end
