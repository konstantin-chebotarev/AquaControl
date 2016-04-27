//
//  acAddFishTankViewController.h
//  AquaControl
//
//  Created by Konstantin Chebotarev on 03/02/2014.
//  Copyright (c) 2014 Konstantin Chebotarev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "acFishTank.h"

@interface acAddFishTankViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property acFishTank *fishTank;

@end
