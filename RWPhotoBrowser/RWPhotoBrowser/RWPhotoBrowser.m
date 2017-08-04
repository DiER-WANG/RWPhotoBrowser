//
//  RWPhotoBrowser.m
//  RWPhotoBrowser
//
//  Created by SSY on 2017/8/4.
//  Copyright © 2017年 SSY. All rights reserved.
//

#import "RWPhotoBrowser.h"

#define kPadding 20

#pragma mark - RWPhotoBrowser

@interface RWPhotoBrowser ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray  *photos;
@property (nonatomic, assign) NSUInteger  currentIndex;

@end

@implementation RWPhotoBrowser

- (instancetype)initWithPhotos:(NSArray *)photos withIndex:(NSUInteger)currentIndex {
    if (self = [super init]) {
        _photos = photos;
        _currentIndex = currentIndex;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) + kPadding, CGRectGetHeight(self.view.frame));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) + kPadding, CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor blackColor];
    [collectionView registerClass:[RWPhotoBrowserCell class] forCellWithReuseIdentifier:@"cell"];
    
    [collectionView setContentOffset:CGPointMake(_currentIndex * ((CGRectGetWidth(self.view.frame) + kPadding)), 0)];
}

#pragma mark collection delegate and data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RWPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.oneTapClick = ^{
        [self dismiss];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

#pragma mark - RWPhotoBrowserCell
@interface RWPhotoBrowserCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView  *imageView;

@end

@implementation RWPhotoBrowserCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) - kPadding, CGRectGetHeight(self.bounds))];
    [self.contentView addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 8.f;
    _scrollView = scrollView;

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    [scrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor magentaColor];
    imageView.image = [UIImage imageNamed:@"2.png"];
    _imageView = imageView;
    
    
    UITapGestureRecognizer * doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Clicked:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [_scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer * oneTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Clicked:)];
    oneTapRecognizer.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:oneTapRecognizer];
    
    [oneTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

}

- (void)tap1Clicked:(UITapGestureRecognizer *)tap {
    if (self.oneTapClick) {
        self.oneTapClick();
    }
}

- (void)tap2Clicked:(UITapGestureRecognizer *)tap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    if(_scrollView.zoomScale == _scrollView.maximumZoomScale){
        [_scrollView setZoomScale:1 animated:YES];
    }else{
        CGPoint touchPoint = [tap locationInView:_imageView];
        [_scrollView zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

@end
