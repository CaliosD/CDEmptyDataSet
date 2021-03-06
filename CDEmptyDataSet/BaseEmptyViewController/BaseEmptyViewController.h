//
//  BaseEmptyViewController.h
//  CDEmptyDataSet
//
//  Created by Calios on 5/3/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCDEmptyDataKey             @"暂无数据"
#define kCDEmptyDataNoNetworkKey    @"暂无网络"
#define kCDEmptyDataNetworkErrorKey @"网络加载失败"

typedef NS_ENUM(NSInteger, EmptyType){
    EmptyType_EmptyData,
    EmptyType_NoNetwork,
    EmptyType_NetworkError
};

@interface BaseEmptyViewController : UIViewController

@property (nonatomic, strong) NSString *emptyTitle;
@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, assign) BOOL needsEmptyDataHandling;

- (void)reloadEmptyDataWithType:(EmptyType)type;
- (void)startLoading;
- (void)stopLoading;

@end
