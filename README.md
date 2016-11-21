# DLCategoryView

Preview :

![N|Solid](https://github.com/dheina/DLCategoryView/blob/master/preview.gif?raw=true)

DLCategoryView is Custom Library for iOS written in Objective-C.

Supported OS : 7.0

### How to use :
##### Using xib/ storyboard
1. Just drag UIView in xib/ storyboard.
2. Assign delegate
3. In View did load add this code for assign UITableView Datasource & Delegate
```
self.categoryView.tableView.delegate = self;
self.categoryView.tableView.dataSource = self;
```
##### Programmatically
1. Add this code for init
```
DLCategoryView *categoryView = [[DLCategoryView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
categoryView.delegate = self;
categoryView.dataSource = self;
categoryView.tableView.dataSource = self;
categoryView.tableView.delegate = self;
[categoryView reloadData];
[self.view addSubview:categoryView];
```



### DLCategoryViewDataSource
```
@protocol DLCategoryViewDataSource <NSObject,UITableViewDataSource>

@required
//Return Number of Item in Grid View
- (int)DLCategoryViewNumberOfItem:(DLCategoryView *)view;
// Return Title of Item at Index
- (NSString*)DLCategoryViewItemNameForIndex:(int)index;
// Return Image of Item at Index
- (UIImage*)DLCategoryViewItemImageForIndex:(int)index;

@end
```

### DLCategoryViewDelegate
```
@protocol DLCategoryViewDelegate <NSObject,UITableViewDelegate>

@optional

- (void)DLCategoryViewDidOpenAtIndex:(int)index;
- (void)DLCategoryViewDidCloseAtIndex:(int)index;

@end
```




Powered by dheina.com

[![N|Solid](https://dheina.com/img/user.jpg)](https://dheina.com)
