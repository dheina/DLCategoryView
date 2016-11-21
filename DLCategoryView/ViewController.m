//
//  ViewController.m
//  DLCategoryView
//
//  Created by Dheina Lundi Ahirsya on 18/11/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.categoryView.tableView.delegate = self;
    self.categoryView.tableView.dataSource = self;
    [super viewDidLoad];
}



#pragma mark DLCategoryView

-(int)DLCategoryViewNumberOfItem:(DLCategoryView *)view
{
    return 12;
}

-(UIImage *)DLCategoryViewItemImageForIndex:(int)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"ImgCat%d",index+1]];
}

-(NSString *)DLCategoryViewItemNameForIndex:(int)index
{
    return [NSString stringWithFormat:@"Category %d",index];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = cell.contentView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.clipsToBounds = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"List %d",(int)indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    //etc.
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.categoryView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.categoryView scrollViewDidScroll:scrollView];
}

@end
