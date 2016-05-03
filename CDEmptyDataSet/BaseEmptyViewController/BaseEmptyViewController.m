//
//  BaseEmptyViewController.m
//  CDEmptyDataSet
//
//  Created by Calios on 5/3/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "BaseEmptyViewController.h"
#import "DGActivityIndicatorView.h"

@interface CDEmptyDataView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSString *defaultTitle;

- (void)setupConstraints;
- (void)prepareForReuse;

@end


@interface BaseEmptyViewController ()

@property (nonatomic, strong) CDEmptyDataView *emptyDataView;
@property (nonatomic, strong) UIView *listView;

@property (nonatomic, strong) DGActivityIndicatorView *activityIndicatorView;

@end

@implementation BaseEmptyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _emptyDataView = [CDEmptyDataView new];
    _emptyDataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _emptyDataView.hidden = YES;
    _emptyDataView.defaultImage = [UIImage imageNamed:@"empty.png"];
    _emptyDataView.defaultTitle = kCDEmptyDataKey;
    [self.view addSubview:_emptyDataView];
    
    _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor orangeColor]];
    _activityIndicatorView.size = 50;
    _activityIndicatorView.center = self.view.center;
    [self.view addSubview:_activityIndicatorView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Reload (Public)

- (void)reloadEmptyDataWithType:(EmptyType)type
{
    [self cd_reloadEmptyDataWithType:type];
}

#pragma mark - Load (Public)

- (void)startLoading
{
    if (!_activityIndicatorView.animating) {
        self.emptyDataView.alpha = 0;
        self.listView.alpha = 0;
        
        [_activityIndicatorView startAnimating];
    }
}

- (void)stopLoading
{
    if (_activityIndicatorView.animating) {
        [_activityIndicatorView stopAnimating];
    }
}

#pragma mark - Reload (Private)

- (void)cd_reloadEmptyDataWithType:(EmptyType)type
{
    switch (type) {
        case EmptyType_EmptyData: {
            self.emptyTitle = @"诶呦喂～～～";
            self.emptyImage = [UIImage imageNamed:@"empty.png"];
            break;
        }
        case EmptyType_NoNetwork: {
            self.emptyTitle = kCDEmptyDataNoNetworkKey;
            self.emptyImage = [UIImage imageNamed:@"network-none.png"];
            break;
        }
        case EmptyType_NetworkError: {
            self.emptyTitle = kCDEmptyDataNetworkErrorKey;
            self.emptyImage = [UIImage imageNamed:@"wifi-error.png"];
            break;
        }
    }
    self.emptyDataView.alpha = 0;
    self.listView.alpha = 0;
    if (_activityIndicatorView.animating) {
        [_activityIndicatorView stopAnimating];
    }
    
    if (_needsEmptyDataHandling && [self cd_itemsCount] == 0) {    // Calios: add networking check.
        
        CDEmptyDataView *view = self.emptyDataView;
        
        if (!view.superview) {
            if ([self.listView isKindOfClass:[UITableView class]] || [self.listView isKindOfClass:[UICollectionView class]]) {
                [self.view insertSubview:view atIndex:0];
            }
            else{
                [self.view addSubview:view];
            }
        }
        
        [view prepareForReuse];
        
        NSString *title = [self cd_emptyTitle];
        UIImage *image = [self cd_emptyImage];
        
        if (title) {
            view.titleLabel.text = title;
        }
        if (image) {
            view.imageView.image = image;
        }
        
        self.listView.hidden = YES;
        
        [view setupConstraints];
        
        [UIView animateWithDuration:0.25 animations:^{
            view.hidden = NO;
            view.alpha = 1.0;
        }];
    }
    else if ([self cd_itemsCount] > 0){
        _emptyDataView.hidden = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.listView.hidden = NO;
            self.listView.alpha = 1.0;
        }];
    }
}

#pragma mark - Getter(Private)

- (UIView *)listView
{
    UIView *l = nil;
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            l = (UITableView *)v;
            break;
        }
        else if ([v isKindOfClass:[UICollectionView class]]){
            l = (UICollectionView *)v;
            break;
        }
    }
    return l;
}

- (NSString *)cd_emptyTitle
{
    return self.emptyTitle ? :_emptyDataView.defaultTitle;
}

- (UIImage *)cd_emptyImage
{
    return self.emptyImage ? :_emptyDataView.defaultImage;
}

- (NSInteger)cd_itemsCount
{
    NSInteger items = 0;

    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)v;
            id <UITableViewDataSource> dataSource = tableView.dataSource;
            
            NSInteger sections = 1;
            
            if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
                sections = [dataSource numberOfSectionsInTableView:tableView];
            }
            
            if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
                for (NSInteger section = 0; section < sections; section++) {
                    items += [dataSource tableView:tableView numberOfRowsInSection:section];
                }
            }
            break;
        }
        else if ([v isKindOfClass:[UICollectionView class]]){
            UICollectionView *collectionView = (UICollectionView *)v;
            id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
            
            NSInteger sections = 1;
            
            if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
                sections = [dataSource numberOfSectionsInCollectionView:collectionView];
            }
            
            if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
                for (NSInteger section = 0; section < sections; section++) {
                    items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
                }
            }
        }
    }
    
    return items;
}

@end

#pragma mark - CDEmptyDataView

@implementation CDEmptyDataView
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.frame = self.superview.bounds;
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.alpha = 1.0;
    }];
}

- (void)setupConstraints
{
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterX multiplier:1.0
                                                                          constant:0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                         attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeCenterY multiplier:1.0
                                                                          constant:0];
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView" : self.contentView}]];
    
    
    CGFloat width = CGRectGetWidth(self.frame) ? : CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat padding = roundf(width/16.0);
    CGFloat verticalSpace = 12.0;
    
    NSMutableArray *subviewStrings = [NSMutableArray array];
    NSMutableDictionary *views = [NSMutableDictionary dictionary];
    NSDictionary *metrics = @{@"padding": @(padding)};
    
    if ([self canShowImage]) {
        [subviewStrings addObject:@"imageView"];
        views[[subviewStrings lastObject]] = _imageView;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                                    attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.contentView
                                                                    attribute:NSLayoutAttributeCenterX multiplier:1.0
                                                                      constant:0]];
    }
    
    if ([self canShowTitle]) {
        [subviewStrings addObject:@"titleLabel"];
        views[[subviewStrings lastObject]] = _titleLabel;
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
    }
    
    NSMutableString *verticalFormat = [NSMutableString new];
    
    for (int i = 0; i < subviewStrings.count; i++) {
        NSString *string = subviewStrings[i];
        [verticalFormat appendFormat:@"[%@]",string];
        
        if (i < subviewStrings.count - 1) {
            [verticalFormat appendFormat:@"-(%.f@750)-",verticalSpace];
        }
    }
    
    if (verticalFormat.length > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat]
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
    }
}

- (void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _imageView = nil;
    
    [self removeAllConstraints];
}

- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
}

#pragma mark - Getters

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = NO;
        _imageView.accessibilityIdentifier = @"empty set image view";
        
        _imageView.image = _defaultImage;
        
        [_contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"empty set title";
        
        _titleLabel.text = _defaultTitle;
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (BOOL)canShowImage
{
    return (_imageView.image && _imageView.superview);
}

- (BOOL)canShowTitle
{
    return (_titleLabel.text.length > 0 && _titleLabel.superview);
}

@end
