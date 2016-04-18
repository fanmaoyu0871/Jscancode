//
//  SJAddressCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJAddressCell.h"

@interface SJAddressCell ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    NSDictionary *_dict;
    NSArray *_province;
    NSArray *_city;
    NSArray *_district;
    
    NSString *_selectedProvince;
    
    UIPickerView *_picker;
    
    NSString *_comp0;
    NSString *_comp1;
    NSString *_comp2;
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation SJAddressCell

- (void)awakeFromNib {
    // Initialization code
    //读取数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_dict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_dict objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [_province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_dict objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    _city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [_city objectAtIndex: 0];
    _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.backgroundColor = [UIColor whiteColor];
    self.textField.inputView = _picker;
    
    UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    accessoryView.backgroundColor = [UIColor whiteColor];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5f)];
    topLine.backgroundColor = RGBHEX(0xf0f0f0);
    [accessoryView addSubview:topLine];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 0.5f)];
    line.backgroundColor = RGBHEX(0xf0f0f0);
    [accessoryView addSubview:line];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:RGBHEX(0x4E82DC) forState:UIControlStateNormal];
    [accessoryView addSubview:cancelBtn];
    
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-80, 0, 80, 40)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitleColor:RGBHEX(0x4E82DC) forState:UIControlStateNormal];
    [accessoryView addSubview:finishBtn];
    
    self.textField.inputAccessoryView = accessoryView;
    self.textField.delegate = self;

}
-(void)showPickView
{
    [self.textField becomeFirstResponder];
}

-(void)cancelBtnAction
{
    [self.textField resignFirstResponder];
}

-(void)finishBtnAction
{
    NSInteger index0 = [_picker selectedRowInComponent:0];
    _comp0 = _province[index0];
    
    NSInteger index1 = [_picker selectedRowInComponent:1];
    _comp1 = _city[index1];
    
    NSInteger index2 = [_picker selectedRowInComponent:2];
    _comp2 = _district[index2];
    
    self.cityLabel.text = [NSString stringWithFormat:@"%@%@%@", _comp0, _comp1, _comp2];
    [self.textField resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return _province.count;
    }
    else if (component == 1)
    {
        return _city.count;
    }
    else if(component == 2)
    {
        return _district.count;
    }
    
    return 0;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return _province[row];
    }
    else if (component == 1)
    {
        return _city[row];
    }
    else if(component == 2)
    {
        return _district[row];
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _selectedProvince = [_province objectAtIndex:row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_dict objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        _city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [_city objectAtIndex: 0]]];
        [_picker selectRow: 0 inComponent: 1 animated: YES];
        [_picker selectRow: 0 inComponent: 2 animated: YES];
        [_picker reloadComponent: 1];
        [_picker reloadComponent: 2];
        
    }
    else if (component == 1) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[_province indexOfObject: _selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_dict objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [_picker selectRow: 0 inComponent: 2 animated: YES];
        [_picker reloadComponent:2];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == 0) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_province objectAtIndex:row];
        myView.font = [UIFont fontWithName:Theme_MainFont size:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == 1) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_city objectAtIndex:row];
        myView.font = [UIFont fontWithName:Theme_MainFont size:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [_district objectAtIndex:row];
        myView.font = [UIFont fontWithName:Theme_MainFont size:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

#pragma mark -  UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.endEditBlock)
    {
        self.endEditBlock(_comp0, _comp1, _comp2);
    }
}

@end
