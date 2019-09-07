//
//  DABannerView.h
//  DABannerView
//
//  Created by linfeng wang on 2019/7/22.
//  Copyright © 2019 linfeng wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DABannerViewSelectItmeBlock)(NSInteger index);

@interface DABannerView : UIView

@property (nonatomic, strong) NSArray *urlStringForImageArr;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, assign) BOOL showPageControl;

@property (nonatomic, assign) CGFloat   durationTime;

@property (nonatomic, copy) DABannerViewSelectItmeBlock selectItmeBlock;

@end

NS_ASSUME_NONNULL_END
