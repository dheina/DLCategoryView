//
//  DLCategoryView.m
//  DLCategoryView
//
//  Created by Dheina Lundi Ahirsya on 18/11/2016.
//  Copyright © 2016 dheina.com. All rights reserved.
//

#import "DLCategoryView.h"


@implementation DLCategoryView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialization];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self resizeUI];
}

-(void)initialization
{
    self.clipsToBounds = YES;
    
    [self layoutIfNeeded];
    
    self.isExpand = NO;
    
    //Container Grid Category;
    self.cntrGridCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.cntrGridCategory.scrollEnabled = YES;
    self.cntrGridCategory.showsVerticalScrollIndicator = NO;
    [self addSubview:self.cntrGridCategory];
    [self generateGridCategory];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0) style:UITableViewStylePlain];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.delegate;
    
    [self addSubview:self.tableView];
}

-(void)reloadData
{
    [self resizeUI];
    [self.tableView reloadData];
}


-(void)generateGridCategory
{
    
    //Remove All Subview
    for (UIView* b in self.cntrGridCategory.subviews){[b removeFromSuperview];}
    
    int totalNumber = [self.dataSource DLCategoryViewNumberOfItem:self];
    int totalCol = (self.frame.size.width/170)+0.5;
    int totalRow = totalNumber/totalCol;
    float weight = self.frame.size.width/totalCol;
    
    
    int index = 0;
    for (int y=0; y<totalRow; y++) {
        for (int x=0; x<totalCol; x++) {
            if(index<totalNumber){
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x*weight, y*weight, weight, weight)];
                view.backgroundColor = [UIColor clearColor];
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, weight, weight)];
                btn.titleLabel.font = [UIFont systemFontOfSize:DLCategoryViewTAGCardTextSize weight:200.0f];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                btn.titleLabel.layer.shadowColor = [[UIColor blackColor]CGColor];
                btn.titleLabel.layer.shadowOffset = CGSizeMake(0.6, 0.6);
                btn.titleLabel.layer.shadowRadius = 2.0;
                btn.titleLabel.layer.shadowOpacity = 0.8;
                
                [btn setTitle:[self.dataSource DLCategoryViewItemNameForIndex:index] forState:UIControlStateNormal];
                
                [btn addTarget:self action:@selector(actionGridItemTapped:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = DLCategoryViewTAGButton;
                
                UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, weight-10, weight-10)];
                
                if (self.dataSource){
                    img.image = [self.dataSource DLCategoryViewItemImageForIndex:index];
                }
                
                img.tag = DLCategoryViewTAGImage;
                img.contentMode = UIViewContentModeScaleAspectFill;
                img.clipsToBounds =  YES;
                [view addSubview:img];
                
                
                UILabel*tag =[[UILabel alloc]init];
                tag.text = [NSString stringWithFormat:@"%d",index];
                tag.tag = DLCategoryViewTAGTag;
                [view addSubview:tag];
                
                
                if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                    
                    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                    blurEffectView.frame = view.bounds;
                    blurEffectView.alpha = 0.0f;
                    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    blurEffectView.tag = DLCategoryViewTAGBlur;
                    [view addSubview:blurEffectView];
                }
                
                
                [view addSubview:btn];
                view.clipsToBounds =  YES;
                
                [self.cntrGridCategory addSubview:view];
            }
            index++;
        }
    }
    [self.cntrGridCategory setContentSize:CGSizeMake(self.cntrGridCategory.frame.size.width, weight*totalRow)];
}

-(void)resizeUI
{
    if(!self.isAnimating){
        
        if(self.isExpand){
            [self hideTableView:self.headerView];
        }
        self.cntrGridCategory.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        [self generateGridCategory];
    }
}


#pragma mark IBAction


-(IBAction)actionGridItemTapped:(id)sender
{
    if(self.isExpand){
        
        if(self.delegate!=nil){
            NSInteger i = [sender tag];
            if(self.delegate && [self.delegate respondsToSelector:@selector(DLCategoryViewDidCloseAtIndex:)]){
                [self.delegate DLCategoryViewDidCloseAtIndex:(int)i];
            }
        }
        
        [self hideTableView:sender];
    }else{
        
        if(self.delegate!=nil){
            NSInteger i = [sender tag];
            if(self.delegate && [self.delegate respondsToSelector:@selector(DLCategoryViewDidOpenAtIndex:)]){
                [self.delegate DLCategoryViewDidOpenAtIndex:(int)i];
            }
        }
        
        [self showTableView:sender];
    }
}


#pragma mark Animate

-(void)showTableView:(UIView*)view
{
    if(self.isAnimating){
        return;
    }
    
    UIView *parentView = [view superview];
    self.headerView = parentView;
    
    [self.tableView reloadData];
    
    
    self.originalPos = parentView.frame;
    self.originalPoint = self.cntrGridCategory.contentOffset;
    
    self.isAnimating = YES;
    for (UIView* b in self.cntrGridCategory.subviews){
        b.tag = 0;
    }
    parentView.tag = DLCategoryViewTAGTempButton;
    
    
    self.cntrGridCategory.scrollEnabled = NO;
    [self.cntrGridCategory bringSubviewToFront:parentView];
    
    [UIView animateWithDuration:0.4f animations:^{
        parentView.frame = CGRectMake(0, 0, self.cntrGridCategory.frame.size.width, self.frame.size.height);
        [self.cntrGridCategory setContentOffset:CGPointMake(0, 0)];
        for (UIView* b in self.cntrGridCategory.subviews){
            if(b.tag!=DLCategoryViewTAGTempButton){
                b.alpha = 0;
                b.transform = CGAffineTransformMakeScale(0.01, 0.01);
                for (UIView* c in b.subviews){
                    //Image
                    if(c.tag==DLCategoryViewTAGBlur){
                        c.alpha =0;
                    }
                    //Button
                    if(c.tag==DLCategoryViewTAGButton){
                        c.transform = CGAffineTransformMakeScale(1, 1);
                    }
                }
            }else{
                b.transform = CGAffineTransformMakeScale(1.0, 1.0);
                for (UIView* c in b.subviews){
                    //Button
                    if(c.tag==DLCategoryViewTAGButton){
                        c.frame = CGRectMake(0, 0, b.frame.size.width, [self gridHeight]);
                        c.transform = CGAffineTransformMakeScale(DLCategoryViewTAGCardTextScaled, DLCategoryViewTAGCardTextScaled);
                    }
                    //Image
                    if(c.tag==DLCategoryViewTAGImage){
                        c.frame = CGRectMake(0, 0, b.frame.size.width, b.frame.size.height);
                    }
                    //Blur
                    if(c.tag==DLCategoryViewTAGBlur){
                        c.alpha = 0.4f;
                    }
                }
            }
        }
        self.tableView.frame = CGRectMake(0, [self gridHeight], self.frame.size.width, self.frame.size.height-[self gridHeight]);
    } completion:^(BOOL finished) {
        if(finished){
            self.isExpand = YES;
            self.isAnimating = NO;
            [self.tableView reloadData];
        }
    }];
}

-(void)hideTableView:(UIView*)view
{
    if(self.isAnimating){
        return;
    }
    UIView *parentView = [view superview];
    self.isAnimating = YES;
    
    [self.cntrGridCategory bringSubviewToFront:parentView];
    [UIView animateWithDuration:0.3f animations:^{
        parentView.frame = self.originalPos;
        [self.cntrGridCategory setContentOffset:self.originalPoint];
        
        for (UIView* b in self.cntrGridCategory.subviews){
            b.transform = CGAffineTransformMakeScale(1.0, 1.0);
            if(b.tag!=DLCategoryViewTAGTempButton){
                b.alpha = 1;
                for (UIView* c in b.subviews){
                    //Image
                    if(c.tag==DLCategoryViewTAGBlur){
                        c.alpha = 0;
                    }
                    //Button
                    if(c.tag==DLCategoryViewTAGButton){
                        c.transform = CGAffineTransformMakeScale(1, 1);
                    }
                }
            }else{
                for (UIView* c in b.subviews){
                    //Button
                    if(c.tag==DLCategoryViewTAGButton){
                        c.frame = CGRectMake(0, 0, b.frame.size.width, b.frame.size.height);
                        c.transform = CGAffineTransformMakeScale(1, 1);
                    }
                    //Image
                    if(c.tag==DLCategoryViewTAGImage){
                        c.frame = CGRectMake(5, 5, b.frame.size.width-10, b.frame.size.height-10);
                    }
                    //Blur
                    if(c.tag==DLCategoryViewTAGBlur){
                        c.alpha = 0.0f;
                    }
                }
            }
        }
        self.tableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        if(finished){
            self.cntrGridCategory.scrollEnabled = YES;
            self.isExpand = NO;
            self.isAnimating = NO;
        }
    }];
}

-(float)gridHeight
{
    return self.frame.size.height*0.2f;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.headerView!=nil && scrollView==self.tableView){
        if(scrollView.contentOffset.y<0 ){
            self.tableView.backgroundColor = [UIColor clearColor];
            float value = (scrollView.contentOffset.y*-1)/300.0f;
            for (UIView* c in self.headerView.subviews){
                //Image
                if(c.tag==DLCategoryViewTAGImage){
                    c.transform = CGAffineTransformMakeScale(1.0+value, 1.0+value);
                }
                //Blur
                if(c.tag==DLCategoryViewTAGBlur){
                    c.alpha = 0.4f+value;
                }
                //Button
                if(c.tag==DLCategoryViewTAGButton){
                    c.transform = CGAffineTransformMakeScale(DLCategoryViewTAGCardTextScaled+value, DLCategoryViewTAGCardTextScaled+value);
                }
            }
        }else{
            self.tableView.backgroundColor = [UIColor whiteColor];
            for (UIView* c in self.headerView.subviews){
                //Image
                if(c.tag==DLCategoryViewTAGImage){
                    c.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }
                //Button
                if(c.tag==DLCategoryViewTAGButton){
                    c.transform = CGAffineTransformMakeScale(DLCategoryViewTAGCardTextScaled, DLCategoryViewTAGCardTextScaled);
                }
            }
        }
    }
}


@end