//
//  acMasterViewController.h
//  AquaControl
//
//  Created by Konstantin Chebotarev on 02/02/2014.
//  Copyright (c) 2014 Konstantin Chebotarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class acDetailViewController;

@interface acMasterViewController : UITableViewController

@property (strong, nonatomic) acDetailViewController *detailViewController;

@end
