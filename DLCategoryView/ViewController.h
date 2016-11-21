//
//  ViewController.h
//  DLCategoryView
//
//  Created by Dheina Lundi Ahirsya on 18/11/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCategoryView.h"

@interface ViewController : UIViewController <DLCategoryViewDataSource,DLCategoryViewDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet DLCategoryView *categoryView;

@end

