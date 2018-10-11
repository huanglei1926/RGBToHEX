//
//  ViewController.m
//  RGBToHEX
//
//  Created by cainiu on 2018/10/11.
//  Copyright © 2018 Len. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *rgbTextField1;
@property (weak) IBOutlet NSTextField *rgbTextField2;
@property (weak) IBOutlet NSTextField *rgbTextField3;
@property (weak) IBOutlet NSButton *rgbTransButton;
@property (weak) IBOutlet NSTextField *rgbTipLabel;
@property (weak) IBOutlet NSTextField *rgbColorView;


@property (weak) IBOutlet NSTextField *hexTextField;
@property (weak) IBOutlet NSButton *hexTransButton;
@property (weak) IBOutlet NSTextField *hexTipLabel;
@property (weak) IBOutlet NSTextField *hexColorView;

@end


// RGB颜色
#define kRGBColor(r, g, b) [NSColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorHexValueAlpha(rgbValue) [NSColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ErrorTipStr @"请输入正确的格式"
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)rgbToHexAction:(NSButton *)sender {
    self.rgbTipLabel.hidden = NO;
    if (![self isRGBValueWithText:self.rgbTextField1.stringValue]) {
        [self.rgbTipLabel setStringValue:ErrorTipStr];
        return;
    }
    if (![self isRGBValueWithText:self.rgbTextField2.stringValue]) {
        [self.rgbTipLabel setStringValue:ErrorTipStr];
        return;
    }
    if (![self isRGBValueWithText:self.rgbTextField3.stringValue]) {
        [self.rgbTipLabel setStringValue:ErrorTipStr];
        return;
    }
    
    [self.rgbTipLabel setStringValue:[self rgbToHexValueWithR:self.rgbTextField1.stringValue g:self.rgbTextField2.stringValue b:self.rgbTextField3.stringValue]];
    self.rgbColorView.hidden = NO;
    self.rgbColorView.backgroundColor = kRGBColor(self.rgbTextField1.intValue, self.rgbTextField2.intValue, self.rgbTextField3.intValue);
}

//RGB转Hex
- (NSString *)rgbToHexValueWithR:(NSString *)r g:(NSString *)g b:(NSString *)b{
    NSString *rHex = [self getHexByDecimal:[r integerValue]];
    NSString *gHex = [self getHexByDecimal:[g integerValue]];
    NSString *bHex = [self getHexByDecimal:[b integerValue]];
    return [NSString stringWithFormat:@"%@%@%@",rHex,gHex,bHex];
}

- (IBAction)hexToRgbAction:(NSButton *)sender {
    self.hexTipLabel.hidden = NO;
    if (![self isHexValueWithText:self.hexTextField.stringValue]) {
        [self.hexTipLabel setStringValue:ErrorTipStr];
        return;
    }
    NSString *hexStr = self.hexTextField.stringValue;
    if (![self.hexTextField.stringValue containsString:@"0x"]) {
        hexStr = [NSString stringWithFormat:@"0x%@",self.hexTextField.stringValue];
    }else{
        if ([self.hexTextField.stringValue containsString:@"#"]) {
            hexStr = [self.hexTextField.stringValue stringByReplacingOccurrencesOfString:@"#" withString:@"0x"];
        }else{
            hexStr = self.hexTextField.stringValue;
        }
    }
    
    
    [self.hexTipLabel setStringValue:[self hexToRGBWithHex:hexStr]];
    self.hexColorView.hidden = NO;
}

//Hex转RGB
- (NSString *)hexToRGBWithHex:(NSString *)hex{
    unsigned long hexValue = strtoul([hex UTF8String],0,16);
    int r = (hexValue >> 16) & 0xFF;
    int g = (hexValue >> 8) & 0xFF;
    int b = (hexValue) & 0xFF;
    self.hexColorView.backgroundColor = kRGBColor(r, g, b);
    return [NSString stringWithFormat:@"%d,%d,%d",r,g,b];
}


- (BOOL)isRGBValueWithText:(NSString *)text{
    if (text == nil || text.length == 0 || text.length > 3) {
        return NO;
    }
    if (![self isAllNumberWithString:text]) {
        return NO;
    }
    NSInteger number = [text integerValue];
    if (number < 0 || number > 255) {
        return NO;
    }
    return YES;
}

- (BOOL)isHexValueWithText:(NSString *)text{
    if (text == nil) {
        return NO;
    }else if (text.length == 8){
        if (![text containsString:@"0x"]) {
            return NO;
        }
    }else if (text.length == 7){
        if (![text containsString:@"#"]) {
            return NO;
        }
    }else if (text.length != 6){
        return NO;
    }
    NSString *tempStr = [text stringByReplacingOccurrencesOfString:@"0x" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (![self isOnlyHasCharacterAndNumber:tempStr]) {
        return NO;
    }
    return YES;
}



//是否仅仅包含颜色字母和数字
- (BOOL)isOnlyHasCharacterAndNumber:(NSString *)text{
//    NSString *regex = @".*[a-z][A-Z][0-9].*";
    NSString *regex =  @"^[A-Fa-f0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

//判断字符串是否全为数字
- (BOOL)isAllNumberWithString:(NSString *)numString
{
    numString = [numString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(numString.length > 0) {
        return NO;
    }
    return YES;
}


/**
 十进制转16进制
 */
- (NSString *)getHexByDecimal:(NSInteger)decimal {
    NSString *hex = @"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i < 9; i++) {
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            break;
        }
    }
    if (hex.length == 1) {
        hex = [@"0" stringByAppendingString:hex];
    }
    return hex;
}


@end
