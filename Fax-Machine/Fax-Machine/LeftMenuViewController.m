//
//  LeftMenuViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/20/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "LeftMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LeftMenuViewController ()

@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - (54 * 6 + 46)) / 2.0f, self.view.frame.size.width, 54 * 6 + 46) style:UITableViewStylePlain];
        
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"homeViewController"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
//        case 1:
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
//                                                         animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        return 100;
    }
    return 54;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0) {
        // The profile photo
        
        static NSString *profileCellIdentifier = @"ProfileCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCellIdentifier];
        
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCellIdentifier];
            
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
            UIImageView *ourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 100, 100)];
            ourImageView.layer.cornerRadius = 50;
            ourImageView.layer.masksToBounds = YES;
            ourImageView.tag = 99;
            ourImageView.contentMode = UIViewContentModeScaleAspectFill;
            
            [cell.contentView addSubview:ourImageView];
        }
        
        UIImageView *ourImageView = [cell viewWithTag:99];
        ourImageView.image = [UIImage imageNamed:@"forest"];
        
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:21];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
        }
        
        NSArray *title = @[@"", @"Home", @"Upload", @"My Images", @"Saved Images", @"Log Out"];
        cell.textLabel.text = title[indexPath.row];
        
        return cell;
    }
}

@end
