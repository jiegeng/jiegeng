//
//  ViewController.m
//  AlarmClock
//
//  Created by MS on 15-8-6.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

/**
  时间没有精确到秒，闹钟设置为不到1分钟，实际是1分钟后响
 */


#import "ViewController.h"
#import "View.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *_hourArray;
    NSMutableArray *_minArray;
    
    UILabel *_timeLabel;
    UIAlertView *_alertView;
    
    int _hour;
    int _min;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _hourArray = [[NSMutableArray alloc] init];
    _minArray = [[NSMutableArray alloc] init];
    
    [self layoutBgView];
    
    // 显示闹钟时间
    _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 40)];
    _timeLabel.textAlignment = 1;
    _timeLabel.font = [UIFont boldSystemFontOfSize:30];
    [self.view addSubview:_timeLabel];

    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelBtn.frame = CGRectMake(20, 190, 60, 40);
    [cancelBtn setTitle:@"取消闹钟" forState:UIControlStateNormal];
    cancelBtn.tag = 1001;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(270, 190, 30, 40);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.tag = 1002;
    [doneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    // 小时
    for (int i = 0; i < 24; i++) {
        if(i < 10)
        {
            NSString *str = [NSString stringWithFormat:@"0%d",i];
            [_hourArray addObject:str];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [_hourArray addObject:str];
        }
    }
    // 分钟
    for (int i = 0; i < 60; i++) {
        if(i < 10)
        {
            NSString *str = [NSString stringWithFormat:@"0%d",i];
            [_minArray addObject:str];
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [_minArray addObject:str];
        }
    }
    

    
}
- (void)layoutBgView
{
    // 导航
    UIView *navView = [View viewWithFrame:CGRectMake(0, 0, 320, 64) andColor:[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f]];
    [self.view addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 120, 44)];
    titleLabel.text = @"闹钟";
    titleLabel.textAlignment = 1;
    [navView addSubview:titleLabel];
    
    UIView *lineView = [View viewWithFrame:CGRectMake(0, 63, 320, 1) andColor:[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]];

    [navView addSubview:lineView];
    
    // 中间两条线
    UIView *bgView = [View viewWithFrame:CGRectMake(0, 189, 320, 1) andColor:[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]];
    [self.view addSubview:bgView];
    
    UIView *bgView1 = [View viewWithFrame:CGRectMake(0, 229, 320, 1) andColor:[UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f]];
    [self.view addSubview:bgView1];
}

- (void)btnClick:(UIButton *)btn
{
    // 取消
    if (btn.tag == 1001)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        _timeLabel.text = @"";
    }
    // 完成闹钟
    else
    {
        // 获取当前时间
        NSString* date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        date = [formatter stringFromDate:[NSDate date]];
        NSArray *datearr = [date componentsSeparatedByString:@" "];
        NSArray *timer=[datearr[1] componentsSeparatedByString:@":"];
    
        NSInteger currentHour = [timer[0] intValue];
        NSInteger currentMin = [timer[1] intValue];
        int currentTotal = currentHour*3600 + currentMin*60;
        int alarmTotal = _hour*3600 + _min*60;
        int ontimer = alarmTotal - currentTotal;
        if(ontimer < 0)
            ontimer = 24*3600 + ontimer;
        NSLog(@"%d",ontimer);
        // 设置闹钟响铃时间
        NSString *hourStr = nil;
        NSString *minStr = nil;
        if(_hour < 10)
            hourStr = [NSString stringWithFormat:@"0%d",_hour];
        else
            hourStr = [NSString stringWithFormat:@"%d",_hour];
        if(_min < 10)
            minStr = [NSString stringWithFormat:@"0%d",_min];
        else
            minStr = [NSString stringWithFormat:@"%d",_min];
        _timeLabel.text = [NSString stringWithFormat:@"%@:%@",hourStr,minStr];
        
        // 时间差
        NSString *timeWakeStr = nil;
        if (ontimer == 60)
            timeWakeStr = [NSString stringWithFormat:@"不到1分钟"];
        else if(ontimer%3600==0)
            timeWakeStr = [NSString stringWithFormat:@"%d小时",ontimer/3600];
        else if(ontimer%3600 != 0 && ontimer/3600!= 0)
            timeWakeStr = [NSString stringWithFormat:@"%d小时%d分钟",ontimer/3600,ontimer%3600/60];
        else if (ontimer%3600 != 0 && ontimer/3600== 0)
            timeWakeStr = [NSString stringWithFormat:@"%d分钟",ontimer%3600/60];
        // 提醒文字
        _alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已将闹钟设置为从现在起%@后提醒",timeWakeStr] message:@" " delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [_alertView show];
        [self performSelectorInBackground:@selector(downloadBegin) withObject:nil];
        
        // 发送通知
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:ontimer];
        notification.soundName = @"kakao短信铃声.caf";//UILocalNotificationDefaultSoundName;
        notification.alertBody = [NSString stringWithFormat:@"懒猪起床!!!"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)downloadBegin
{
    [NSThread sleepForTimeInterval:3];
    [self performSelectorOnMainThread:@selector(downloadFinish) withObject:nil waitUntilDone:NO];
}
- (void)downloadFinish
{
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark-pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
        return 24;
    else
        return 60;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
        return _hourArray[row];
    else
        return _minArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
        _hour = [_hourArray[row] intValue];
    else
        _min = [_minArray[row] intValue];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
