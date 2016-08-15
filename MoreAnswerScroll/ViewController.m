//
//  ViewController.m
//  TestJS
//
//  Created by tonniegao on 16/7/28.
//  Copyright © 2016年 lagou. All rights reserved.
//

#import "ViewController.h"
#import "UIView+CVUIViewAdditions.h"

#define webView_contentInset_y 0
#define webView_pull_y 100

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView * scrollView;//
@property(nonatomic, strong) NSMutableArray *webArray;//储存3个卡片
@property(nonatomic, assign) int index;               //第几条内容
@property(nonatomic, assign) int topViewIndex;        //3个卡片里 最上方的卡片是在webArray里index
@property(nonatomic, strong) NSMutableArray *dataArray;//储存数据
@property(nonatomic, assign) int dataCount;            //数据的个数

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[[UIView alloc] init]];
    
    _dataArray = [NSMutableArray array];
    _webArray = [NSMutableArray array];
    _dataCount = 5;
    _topViewIndex = 0;
    _index = 0;
    
    //自定义几条假数据
    for (int i = 0; i < _dataCount; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"答案第%d页<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>呀<br><br>滚<br>到<br>头<br>了<br>", i]];
    }
    
    //初始化scrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    _scrollView.scrollEnabled = NO;
    
    //插入三张卡片
    for (int i = 0; i < 3; i++) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, i *_scrollView.height, _scrollView.width, _scrollView.height)];
        webView.scrollView.contentInset = UIEdgeInsetsMake(webView_contentInset_y, 0, 0, 0);
        [webView loadHTMLString:@"" baseURL:nil];
        webView.scrollView.delegate = self;
        
        [_scrollView addSubview:webView];
        [_webArray addObject:webView];
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.width, _scrollView.height * 3);
    _scrollView.contentOffset = CGPointMake(0, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    
    
    //先加载第一条数据 在中间的卡片(三张卡片循环移动位置 正在显示的始终保存在中间）
    UIWebView *showView = [_webArray objectAtIndex:1];
    [showView loadHTMLString:[_dataArray objectAtIndex:_index] baseURL:nil];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y + scrollView.height > scrollView.contentSize.height + webView_pull_y) {
        //-------向下滚
        if (_index == [_dataArray count] - 1) {
            NSLog(@"no 下面没有数据了哦");
            return;
        } else {
            _index++;
        }
        
        //移动卡片
        UIWebView *topV = [_webArray objectAtIndex:_topViewIndex];
        topV.top += (_scrollView.height *3);
        
        //初始化 即将要展示的webView
        UIWebView *lastV = [_webArray objectAtIndex:(_topViewIndex + 2)%3];
        [lastV loadHTMLString:[_dataArray objectAtIndex:_index] baseURL:nil];
        lastV.scrollView.contentOffset = CGPointMake(0, -webView_pull_y);
        
        //向下滚动页面
        _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.contentSize.height + _scrollView.height);
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y + _scrollView.height) animated:YES];
        
        _topViewIndex = (_topViewIndex+1)  % 3;
        
    } else if (scrollView.contentOffset.y < -(webView_pull_y + webView_contentInset_y)) {
        //-------向上滚
        if (_index == 0) {
            NSLog(@"no 上面没有数据了哦");
            return;
        } else {
            _index--;
        }
        
        //初始化 即将要展示的webView
        UIWebView *topV = [_webArray objectAtIndex:_topViewIndex];
        [topV loadHTMLString:[_dataArray objectAtIndex:_index] baseURL:nil];
        topV.scrollView.contentOffset = CGPointMake(0, -webView_pull_y);
        
        //移动卡片
        UIWebView *lastV = [_webArray objectAtIndex:(_topViewIndex + 2)%3];
        lastV.top -= (_scrollView.height *3);
        
        //向上滚动页面
        _scrollView.contentSize = CGSizeMake(_scrollView.width, _scrollView.contentSize.height - _scrollView.height);
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y - _scrollView.height) animated:YES];
        
        _topViewIndex = (_topViewIndex+2)  % 3;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
