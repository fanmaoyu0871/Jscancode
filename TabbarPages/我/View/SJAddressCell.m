//
//  SJAddressCell.m
//  Jscancode
//
//  Created by 范茂羽 on 16/4/17.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "SJAddressCell.h"
#import "HZAreaPickerView.h"

@interface SJAddressCell ()<UITextFieldDelegate, HZAreaPickerDelegate>
{
    NSString *_province;
    NSString *_city;
    NSString *_area;
    
    NSString *_address;
}

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation SJAddressCell

-(void)configUI:(NSString*)text vc:(UIViewController*)vc
{
    self.viewController = vc;
    
    self.cityLabel.text = text;
    
}

-(void)layoutSubviews
{
    self.locatePicker.x = 0;
    self.locatePicker.width = ScreenWidth;
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        
        
        _province = picker.locate.state;
        _city = picker.locate.city;
        _area = picker.locate.district;
        
        
        if(_area == nil || _area.length == 0)
        {
            _address = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.state, picker.locate.city];

        }
        else
        {
            _address = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        }
        
        self.cityLabel.text = _address;
        
        [self textFieldDidEndEditing:self.textField];

    }
}


- (void)awakeFromNib {
    
    self.textField.delegate = self;

}



-(void)showPickView
{
    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
    [self.locatePicker showInView:self.viewController.view];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -  UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.endEditBlock)
    {
        if(_area == nil || _area.length == 0)
        {
            _area = _city;
            _city = _province;
        }
        self.endEditBlock(_province, _city, _area);
    }
}

@end
