//
//  DABannerFlowLayout.m
//  DABannerView
//
//  Created by linfeng wang on 2019/7/22.
//  Copyright © 2019 linfeng wang. All rights reserved.
//

#import "DABannerFlowLayout.h"

@implementation DABannerFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
