//
//  HomePageViewController.m
//  iYuBaHomePageDemo
//
//  Created by WQ on 2018/10/19.
//  Copyright © 2018年 WQ. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageSegmentView.h"
#import "WQBannerLoopView.h"
#import "HomePageModel.h"
#import "HomePageCell.h"

@interface HomePageViewController ()
<
WQBannerLoopViewDelegate,
NSXMLParserDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) HomePageSegmentView *segmentV;
@property (nonatomic, strong) WQBannerLoopView *bannerView;
@property (nonatomic, strong) UITableView *tableV;

@property (nonatomic, strong) NSMutableArray <HomePageModel *>*models;
@property (nonatomic, strong) NSArray *bannerUrlArr;

@end

@implementation HomePageViewController{
    NSMutableString *currentElementValue;
    HomePageModel *aModel;
    BOOL storingFlag;
    NSArray *elementToParse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColorFromRGB(0x908f8f);
    
    [self setNav];
    [self configSUbViews];
    [self setSubViewsBlock];
    
    
    self.tableV.tableHeaderView = self.bannerView;
    // 轮播图支持数据切换，懒加载里放了几张本地图先看着   网络数据回来会更新
    [self.bannerView setPageControlOriginType:(WQBannerPageControlOriginType_bottom)];

    
#warning 此时可以转个菊花了  parserDidEndDocument方法内停下
    elementToParse = [[NSArray alloc] initWithObjects:@"Title_cn",@"BbcId",@"DescCn",@"Pic",@"ReadCount",@"CreatTime", nil];
    // 请求得到的内容可见本地文件 DataSource 文件
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://apps.iyuba.com/minutes/titleNewApi.jsp?maxid=0&format=xml&type=iOS"]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    
    [parser parse];
}

- (void)configSUbViews{
    [self.segmentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAVBAR_HEIGHT);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.segmentV.mas_bottom).mas_offset(2);
    }];
}

- (void)setSubViewsBlock{
//    此时切换，想切数据就换数据源，换页面就换页面，和轮播图玩法同源
    
    
    WS(ws);
    [self.segmentV setBBCSixMinutesblock:^{
        [ws showAlertWith:@"点击了 BBC六分钟"];
    }];
    
    [self.segmentV setBBCEnglishblock:^{
        [ws showAlertWith:@"点击了 地道英语"];
    }];
    
    [self.segmentV setBBCNewsblock:^{
        [ws showAlertWith:@"点击了 BBC新闻"];
    }];
    
    [self.segmentV setNewsWordsblock:^{
        [ws showAlertWith:@"点击了 新闻词汇"];
    }];
}

#pragma mark - nav
- (void)setNav{
    //此处简单设置下    需要的话，可以自定义导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:69/255. green:150/255. blue:106/255. alpha:1];
    
    UIButton *leftBtn = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_logo"] selectedImage:nil];
    [leftBtn addTarget:self action:@selector(leftNavButton_action:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithImage:[UIImage imageNamed:@"icon_home_nav_top_right"] selectedImage:nil];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 24., NAVBAR_HEIGHT - 44., 44., 44.);
    [rightBtn addTarget:self action:@selector(rightNavButton_action:) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)leftNavButton_action:(UIButton *)btn{
    [self showAlertWith:@"点击了LOGO"];
}

- (void)rightNavButton_action:(UIButton *)btn{
    [self showAlertWith:@"去首页"];
}

- (void)showAlertWith:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - banner delegate
- (void)wq_bannerLoopViewClicked:(NSUInteger)idx data:(id)data{
    [self showAlertWith:[NSString stringWithFormat:@"点击了轮播图的第 %ld 张", idx]];
}

#pragma mark - xml delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"start");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"end");
    __block NSMutableArray *tmpArr = @[].mutableCopy;
    [self.models enumerateObjectsUsingBlock:^(HomePageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpArr addObject:obj.imgUrl];
    }];
    self.bannerUrlArr = [tmpArr mutableCopy];
    self.bannerView.urlImageArr = self.bannerUrlArr;
    elementToParse = nil;
    [self.tableV reloadData];
#warning 若是在这次请求前转了菊花，此时停下
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
     if([elementName isEqualToString:@"Bbctitle"]) {
        
        aModel = [[HomePageModel alloc] init];
        aModel.bbcID = [attributeDict objectForKey:@"BbcId"];
        
    }
    storingFlag = [elementToParse containsObject:elementName];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (storingFlag) {
        if (!currentElementValue) {
            currentElementValue = [[NSMutableString alloc] initWithString:string];
        }
        else {
            [currentElementValue appendString:string];
        }
    }
    
}



- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"Bbctitle"]) {
        [self.models addObject:aModel];
        aModel = nil;
    }
    
    if (storingFlag) {
        NSString *trimmedString = [currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [currentElementValue setString:@""];
        
        if ([elementName isEqualToString:@"Title_cn"]) {
            aModel.title = trimmedString;
        }else if ([elementName isEqualToString:@"Pic"]) {
            aModel.imgUrl = trimmedString;
        }else if ([elementName isEqualToString:@"CreatTime"]) {
            aModel.creatTime = trimmedString;
        }else if ([elementName isEqualToString:@"BbcId"]) {
            aModel.bbcID = trimmedString;
        }else if ([elementName isEqualToString:@"ReadCount"]) {
            aModel.readCount = trimmedString;
        }else if ([elementName isEqualToString:@"DescCn"]) {
            aModel.descCn = trimmedString;
        }
        
        //后续挑战到二级页面要用的字段没有解析
        //模型里加上属性，此处set即可
    }
    
}
#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT * 0.18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageTBCell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    
    return cell;
}

#pragma mark - lazy
- (HomePageSegmentView *)segmentV{
    if (!_segmentV) {
        _segmentV = [[HomePageSegmentView alloc] initWithXib];
        [self.view addSubview:_segmentV];
    }
    return _segmentV;
}

- (WQBannerLoopView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[WQBannerLoopView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 210)];
        _bannerView.delegate = self;
        
        _bannerView.localImageArr = @[@"IMG_1.JPG",@"IMG_2.JPG",@"IMG_3.JPG",@"IMG_4.JPG"];
        
//        WQBannerDataModel *m1 = [[WQBannerDataModel alloc]init];
//        m1.title = @"第一个标题";
//        m1.url = @"http://a.hiphotos.baidu.com/image/pic/item/d043ad4bd11373f0924d8948af0f4bfbfaed04f2.jpg";
//        WQBannerDataModel *m2 = [[WQBannerDataModel alloc]init];
//        m2.title = @"";
//        m2.url = @"http://h.hiphotos.baidu.com/image/pic/item/377adab44aed2e73ac116e278b01a18b86d6fac5.jpg";
//        WQBannerDataModel *m3 = [[WQBannerDataModel alloc]init];
//        m3.title = nil;
//        m3.url = @"http://b.hiphotos.baidu.com/image/pic/item/6159252dd42a28341d491d0057b5c9ea14cebfc9.jpg";
//        WQBannerDataModel *m4 = [[WQBannerDataModel alloc]init];
//        m4.title = @"哈哈哈哈哈哈啊哈哈哈";
//        m4.url = @"http://c.hiphotos.baidu.com/image/pic/item/a9d3fd1f4134970a22f7b22199cad1c8a7865d33.jpg";
//        WQBannerDataModel *m5 = [[WQBannerDataModel alloc]init];
//        m5.title = @"嘿嘿😜";
//        m5.url = @"http://a.hiphotos.baidu.com/image/pic/item/faf2b2119313b07eaad49f0c00d7912397dd8c4d.jpg";
//        _bannerView.bannerModelList = @[m1,m2,m3,m4,m5];
       
//        _bannerView.urlImageArr = @[@"http://f.hiphotos.baidu.com/image/pic/item/cc11728b4710b912dd54648dcffdfc039245222f.jpg"
//                                    ,@"http://a.hiphotos.baidu.com/image/pic/item/902397dda144ad34e98003fedca20cf431ad8588.jpg"
//                                    ,@"http://b.hiphotos.baidu.com/image/pic/item/48540923dd54564e93914734bfde9c82d0584fc2.jpg"
//                                    ,@"http://a.hiphotos.baidu.com/image/pic/item/4034970a304e251f0d23c284ab86c9177e3e53f1.jpg"
//                                    ,@"http://g.hiphotos.baidu.com/image/pic/item/7c1ed21b0ef41bd51b87ce885dda81cb38db3df1.jpg"
//                                    ,@"http://d.hiphotos.baidu.com/image/pic/item/0e2442a7d933c8951aa8be07dd1373f0830200f3.jpg"
//                                    ,@"http://c.hiphotos.baidu.com/image/pic/item/79f0f736afc3793168613ff0e0c4b74542a911d9.jpg"
//                                    ,@"http://c.hiphotos.baidu.com/image/pic/item/faf2b2119313b07e202c14dd07d7912396dd8c56.jpg"].mutableCopy;
        
    }
    return _bannerView;
}

- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.backgroundColor  = [UIColor whiteColor];
        
        _tableV.estimatedRowHeight = 0;
        _tableV.estimatedSectionHeaderHeight = 0;
        _tableV.estimatedSectionFooterHeight = 0;
        _tableV.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.view addSubview:_tableV];
        
        AdjustsScrollViewInsetNever(self, _tableV);
        
        [_tableV registerNib:[UINib nibWithNibName:@"HomePageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomePageTBCell"];
        
        //翻页完全可以MJrefresh
        
    }
    return _tableV;
}

- (NSMutableArray<HomePageModel *> *)models{
    if (!_models) {
        _models = @[].mutableCopy;
    }
    return _models;
}

@end
