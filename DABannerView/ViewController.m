//
//  ViewController.m
//  DABannerView
//
//  Created by linfeng wang on 2019/7/22.
//  Copyright © 2019 linfeng wang. All rights reserved.
//

#import "ViewController.h"
#import "DABannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = self.view.frame;
    rect.size.height = 200;
    DABannerView *bannerView = [[DABannerView alloc] initWithFrame:rect];
    bannerView.urlStringForImageArr = @[@"http://attachments.gfan.com/forum/attachments2/201301/29/1256236ax4jx99h0m2amxm.jpg",
          @"http://b-ssl.duitang.com/uploads/blog/201510/14/20151014230541_WL32e.jpeg",
          @"http://attachments.gfan.com/forum/attachments2/day_111029/1110290127f0baf0a5adecd422.jpg",
          @"http://pic27.nipic.com/20130312/9402506_175902292125_2.jpg"
                                        ];
    bannerView.selectItmeBlock = ^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    };
    [self.view addSubview:bannerView];
}


@end
