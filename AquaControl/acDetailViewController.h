//
//  acDetailViewController.h
//  AquaControl
//
//  Created by Konstantin Chebotarev on 02/02/2014.
//  Copyright (c) 2014 Konstantin Chebotarev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface acDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
