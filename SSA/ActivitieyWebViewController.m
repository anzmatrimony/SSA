//
//  ActivitieyWebViewController.m
//  SSA
//
//  Created by Sunera on 7/17/17.
//  Copyright © 2017 surya. All rights reserved.
//

#import "ActivitieyWebViewController.h"

@interface ActivitieyWebViewController ()<UIWebViewDelegate>

@end

@implementation ActivitieyWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [webView setUserInteractionEnabled:YES];
    [webView setDelegate:self];
    
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    [self.view addSubview:webView];
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlToLoad]]];
    [webView setScalesPageToFit:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
