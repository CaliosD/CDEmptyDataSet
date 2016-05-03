//
//  ListViewController.m
//  CDEmptyDataSet
//
//  Created by Calios on 4/27/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.needsEmptyDataHandling = YES;
    self.title = @"CDEmptyDataSet";
    
    _data = @[];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self loadingData];
    
    UIBarButtonItem *emptyItem = [self createItemWithTitle:@"Empty" selector:@selector(reloadList)];
    self.navigationItem.rightBarButtonItem = emptyItem;
    
    UIBarButtonItem *networkFailItem = [self createItemWithTitle:@"Fail" selector:@selector(networkFailed)];
    UIBarButtonItem *noNetworkItem = [self createItemWithTitle:@"None" selector:@selector(noNetwork)];
    UIBarButtonItem *loadingItem = [self createItemWithTitle:@"Loading" selector:@selector(loadingData)];

    self.navigationItem.leftBarButtonItems = @[networkFailItem,noNetworkItem,loadingItem];
}

#pragma mark - Action
/**
 *  Empty data example.
 */
- (void)reloadList
{
    if (_data.count == 0) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [tmp addObject:[NSString stringWithFormat:@"Cell %d",i]];
        }
        _data = [NSArray arrayWithArray:tmp];
    }
    else{
        self.emptyTitle = @"诶呦喂～～～";
        self.emptyImage = [UIImage imageNamed:@"empty.png"];
        _data = @[];
    }

    [self reloadListData];
}

/**
 *  Network failed example.
 */
- (void)networkFailed
{
    self.emptyTitle = kCDEmptyDataNetworkErrorKey;
    self.emptyImage = [UIImage imageNamed:@"wifi-error.png"];
    
    _data = @[];
    
    [self reloadListData];
}

/**
 *  No network example.
 */
- (void)noNetwork
{
    self.emptyTitle = kCDEmptyDataNoNetworkKey;
    self.emptyImage = [UIImage imageNamed:@"network-none.png"];
    
    _data = @[];

    [self reloadListData];
}

/**
 *  Loading data example.
 */
- (void)loadingData
{
    [self startLoading];
}

#pragma mark - Private

- (void)reloadListData
{
    [_tableView reloadData];
    [self reloadEmptyData];
}

- (UIBarButtonItem *)createItemWithTitle:(NSString *)title selector:(SEL)sel
{
    UIBarButtonItem *result = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:sel];
    return result;
}

#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = _data[indexPath.row];
    
    return cell;
}

@end
