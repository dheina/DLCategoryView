//
//  DLCategoryView.h
//  DLCategoryView
//
//  Created by Dheina Lundi Ahirsya on 18/11/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

#define DLCategoryViewTAGButton 100
#define DLCategoryViewTAGImage 101
#define DLCategoryViewTAGBlur 102
#define DLCategoryViewTAGTag 103


#define DLCategoryViewTAGTempButton 1000

#define DLCategoryViewTAGCardTextSize 12.0f
#define DLCategoryViewTAGCardTextScaled 1.4f


@class DLCategoryView;

@protocol DLCategoryViewDataSource <NSObject,UITableViewDataSource>

@required

- (int)DLCategoryViewNumberOfItem:(DLCategoryView *)view;
- (NSString*)DLCategoryViewItemNameForIndex:(int)index;
- (UIImage*)DLCategoryViewItemImageForIndex:(int)index;

@end

@protocol DLCategoryViewDelegate <NSObject,UITableViewDelegate>

@optional

- (void)DLCategoryViewDidOpenAtIndex:(int)index;
- (void)DLCategoryViewDidCloseAtIndex:(int)index;

@end

@interface DLCategoryView : UIView <UIScrollViewDelegate>


@property (weak) IBOutlet id <DLCategoryViewDataSource> dataSource;
@property (weak) IBOutlet id <DLCategoryViewDelegate> delegate;

@property (strong, nonatomic) UIScrollView *cntrGridCategory;
@property (strong, nonatomic) UITableView *tableView;

@property (weak, atomic) UIView *headerView;


-(void)reloadData;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@property int openedIndex;

@property CGRect originalPos;
@property CGPoint originalPoint;

@property BOOL isAnimating;
@property BOOL isExpand;

@end
