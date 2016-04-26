//
//  SJDailiResultVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJDailiResultVC.h"
#import "SJDailiModel.h"

@interface SJDailiResultVC ()
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@property (weak, nonatomic) IBOutlet UILabel *numberlabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation SJDailiResultVC

-(NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navTitle = @"代理查询";
    
    [self requestDailiData];
}

#pragma mark - 请求物流单号数据
-(void)requestDailiData
{
    if(!self.numberStr)
    {
        [YDJProgressHUD showTextToast:@"未输入查询号码" onView:self.view];
        return;
    }
    
    NSDictionary *params = @{@"name":@"scancode.sys.agency.search", @"agency_id":self.numberStr};
    
    [QQNetworking requestDataWithQQFormatParam:params view:self.view success:^(NSDictionary *dic) {
        
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSArray class]])
        {
            NSArray *tmpArray = obj;
            
            for(id tmpObj in tmpArray)
            {
                if([tmpObj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = tmpObj;
                    
                    SJDailiModel *model = [[SJDailiModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
            }
            
            [self configUI];
            
        }
        
    } failure:^{
        
    }];
}

-(void)configUI
{
    if(self.dataArray.count > 0)
    {
        SJDailiModel *model = [self.dataArray firstObject];
        
        self.flagImageView.image = [model.validation integerValue] == 1?[UIImage imageNamed:@"zhengpin"]:[UIImage imageNamed:@"jiahuo"];
        self.numberlabel.text = [NSString stringWithFormat:@"您输入的手机号为：%@", model.phone];
        
        self.detailLabel.text = [model.validation integerValue] == 1?@"该代理商是公司授权修芙俪品牌代理商（总代理），请放心购买":@"该代理信息没查到，请谨慎购买，以防假货";
        
        self.imageView.hidden = [model.validation integerValue] == 1?NO:YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
