//
//  WebViewController.m
//  shopping
//
//  Created by LiZujian on 13-8-1.
//  Copyright (c) 2013年 LiZujian. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
{
    NSString* _urlString;
}

@property (retain, nonatomic) UIWebView *webview;
//@property (retain, nonatomic) UIButton *backButton;
//- (void)backAction:(id)sender;
@end

@implementation WebViewController

@synthesize webview = _webview;
//@synthesize backButton
-(void)setUrlString:(NSString *)inputUrlString
{
    if (![_urlString isEqualToString:inputUrlString]) {
        _urlString = [inputUrlString copy];
        
        NSURL* url = [NSURL URLWithString:[_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (url) {
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            if (request) {
                [self.webview loadRequest:request];
            }
        }
    }
}

- (void)dealloc
{
    self.webview = nil;
    [_urlString release];
    _urlString = nil;
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setWebview:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *barButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissVC)]autorelease];
    barButtonItem.tintColor = RGB(255, 188, 205);
//    barButtonItem.t
//    barButtonItem.title = @"完成";
    self.navigationItem.leftBarButtonItem = barButtonItem;
//    [self.navigationItem.leftBarButtonItem setTitle:@"完成"];
    CGRect frame = self.view.frame;
    frame.origin = CGPointZero;
    _webview = [[UIWebView alloc]initWithFrame:frame];
    _webview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_webview sizeToFit];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    [self showLoadingView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webview stopLoading];
}

-(void)dismissVC
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [self.loadingImage setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self.loadingImage setHidden:YES];
    [self hideLoadingView];
    NSLog(@"webview fininsh loading %@", [webView.request.URL absoluteString]);
    NSString* absoluteString = [webView.request.URL absoluteString];
    if ([absoluteString rangeOfString:@"http://detail.tmall.com/"].length>0) {
        /////this is a web version url of tmall, need to converse to mobile version url
        //http://a.m.tmall.com/i14568464658.htm
        
        NSArray* substrings = [absoluteString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?&"]];
        
        
        
        @try {
            NSString* idstring = [substrings objectAtIndex:1];
            NSString* subIdString = [idstring substringFromIndex:3];
            NSString* wapString = [@"" stringByAppendingFormat:@"http://a.m.tmall.com/i%@.htm",subIdString];
            _urlString = wapString;
            NSURL* url = [NSURL URLWithString:[_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if (url)
            {
                NSURLRequest* request = [NSURLRequest requestWithURL:url];
                if (request)
                {
                    [self.webview loadRequest:request];
                }
            }
        }
        @catch (NSException *exception) {
            ///todo
        }
        
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [self.loadingImage setHidden:YES];
    [self hideLoadingView];
}


@end
