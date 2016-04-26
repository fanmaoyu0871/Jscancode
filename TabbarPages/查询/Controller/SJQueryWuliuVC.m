//
//  SJQueryWuliuVC.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/16.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJQueryWuliuVC.h"
#import "SJWuliuResultVC.h"

#define cellID @"cellID"

@interface SJQueryWuliuVC ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searbar;

@end

@implementation SJQueryWuliuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navTitle = @"";
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self createSearch];
    
    [self addTapGesture];
}

-(void)createSearch
{
    self.searbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 27, ScreenWidth-60, 30)];
    self.searbar.delegate = self;
    self.searbar.placeholder = @"输入快递单号";
    self.searbar.tintColor = Theme_MainColor;
    self.searbar.backgroundImage = [UIImage imageNamed:@"navBar"];
    self.searbar.returnKeyType = UIReturnKeySearch;
    [self.navBar addSubview:self.searbar];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 27, 60, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:cancelBtn];
}

- (void)cancelBtnAction
{
    [self.searbar endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searbar endEditing:YES];

    SJWuliuResultVC *vc = [[SJWuliuResultVC alloc]initWithNibName:@"SJWuliuResultVC" bundle:nil];
    vc.orderId = searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

@end
