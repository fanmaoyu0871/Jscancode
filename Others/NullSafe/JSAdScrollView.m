//
//  JSAdScrollView.m
//  JeeSea
//
//  Created by 范茂羽 on 15/9/7.
//  Copyright (c) 2015年 范茂羽. All rights reserved.
//

#import "JSAdScrollView.h"
#import "SJAdModel.h"
#import "SJWebVC.h"
#import "AppDelegate.h"

#define ADImageViewTag 2500

@interface JSAdScrollView ()<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    UIActivityIndicatorView *_indicatorView;
}

@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)NSTimer *timer;


@property (nonatomic, assign)BOOL isRequestSucc;


@end

@implementation JSAdScrollView

-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = false;
        [self addSubview:self.scrollView];
        self.isRequestSucc = NO;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = true;
        _indicatorView.center = CGPointMake(ScreenWidth/2, self.height/2);
        [self addSubview:_indicatorView];
        [self bringSubviewToFront:_indicatorView];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self requestAdData];

    }
    
    return self;
}

-(void)requestAdData
{
    [_indicatorView startAnimating];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"scancode.sys.official.info"}];
    if([YDJUserInfo sharedUserInfo].token)
    {
        [params setObject:[YDJUserInfo sharedUserInfo].token forKey:@"token"];
    }
    
    [QQNetworking requestDataWithQQFormatParam:params view:nil success:^(NSDictionary *dic) {
        [_indicatorView stopAnimating];
        
        id obj = dic[@"data"];
        if([obj isKindOfClass:[NSArray class]])
        {
            NSArray *array = obj;
            NSMutableArray *urlStrArray = [NSMutableArray array];
            for(id obj in array)
            {
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = obj;
                    SJAdModel *model = [[SJAdModel alloc]init];
                    [model setValuesForKeysWithDictionary:dict];
                    [self.dataArray addObject:model];
                    
                    NSString *urlStr =  dict[@"img"];
                    [urlStrArray addObject:urlStr];
                }
            }
            
            NSInteger count = [urlStrArray count];
            
            //前后添加图片实现循环滚动
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:urlStrArray];
            if(tmpArray.count > 1)
            {
                [tmpArray insertObject:urlStrArray[count-1] atIndex:0];
                [tmpArray addObject:urlStrArray[0]];
                
                [self.dataArray insertObject:self.dataArray[count-1] atIndex:0];
                [self.dataArray addObject:self.dataArray[0]];
            }
            
            CGFloat width = self.width;
            CGFloat height = self.height;
            for(NSInteger i = 0; i < tmpArray.count; i++)
            {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width*i, 0, width, height)];
                imageView.tag = ADImageViewTag + i;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                NSString *picPath = [NSString stringWithFormat:@"%@", tmpArray[i]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:picPath]];
                imageView.userInteractionEnabled = YES;
                [self.scrollView addSubview:imageView];
                
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
                [imageView addGestureRecognizer:tapGes];
            }
            
            self.scrollView.contentSize = CGSizeMake(tmpArray.count*width, height);
            
            //创建pageControl
            _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.height-20, ScreenWidth, 20)];
            _pageControl.numberOfPages = count;
            _pageControl.currentPageIndicatorTintColor = Theme_MainColor;
            _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
            _pageControl.hidesForSinglePage = YES;
            [self addSubview:_pageControl];
            
            [self.timer setFireDate:[NSDate distantPast]];
        }
    } failure:^{
        [_indicatorView stopAnimating];
    }];
}

-(void)tapAction:(UIGestureRecognizer*)ges
{
    UIImageView *imageView = (UIImageView*)ges.view;
    NSInteger tag = imageView.tag - ADImageViewTag;
    
    if(tag < self.dataArray.count)
    {
        SJAdModel *model = self.dataArray[tag];
        
        //跳转
        SJWebVC *webVC = [[SJWebVC alloc]initWithNibName:@"SJWebVC" bundle:nil];
        webVC.urlStr = model.url;
        
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        UITabBarController *rootVC = (UITabBarController *)appDelegate.window.rootViewController;
        UINavigationController *navVC = [rootVC.viewControllers objectAtIndex:1];
        [navVC pushViewController:webVC animated:YES];
    }
}


-(void)updateTimer
{
    if(self.scrollView.isDragging)
        return;
    
    if(self.scrollView.contentSize.width/self.scrollView.width > 1)
    {
        NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
        [self.scrollView setContentOffset:CGPointMake(index*self.scrollView.width+self.scrollView.width, 0) animated:YES];
    }
}

-(void)reloadData
{
    if(!self.isRequestSucc)
    {
        [self requestAdData];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x <= 0)
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentSize.width-2*scrollView.bounds.size.width, 0);
    }
    
    if(scrollView.contentOffset.x >= scrollView.contentSize.width-scrollView.width)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    
    if(scrollView.contentOffset.x == (scrollView.contentSize.width - scrollView.width))
    {
        _pageControl.currentPage = 0;
    }
    else if (scrollView.contentOffset.x == 0)
    {
        _pageControl.currentPage = (scrollView.contentSize.width - 2*scrollView.width)/scrollView.width - 1;
    }
    else
    {
        _pageControl.currentPage = (scrollView.contentOffset.x-scrollView.width)/self.width + 0.5;
    }

}



@end
