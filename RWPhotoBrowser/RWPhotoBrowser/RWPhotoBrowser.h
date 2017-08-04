//
//  RWPhotoBrowser.h
//  RWPhotoBrowser
//
//  Created by SSY on 2017/8/4.
//  Copyright © 2017年 SSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWPhotoBrowser : UIViewController

- (instancetype)initWithPhotos:(NSArray *)photos withIndex:(NSUInteger)currentIndex;

@end

@interface RWPhotoBrowserCell : UICollectionViewCell

// 消失
@property (nonatomic, copy) void (^oneTapClick)(void);

@end
