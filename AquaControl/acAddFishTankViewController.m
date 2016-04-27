						//
//  acAddFishTankViewController.m
//  AquaControl
//
//  Created by Konstantin Chebotarev on 03/02/2014.
//  Copyright (c) 2014 Konstantin Chebotarev. All rights reserved.
//

#import "acAddFishTankViewController.h"
#import <arpa/inet.h>

@interface acAddFishTankViewController ()
{
    UITextField *activeField;
}

@property (weak, nonatomic) IBOutlet UITextField *tankNameText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *tankIP;
@property (weak, nonatomic) IBOutlet UITextField *tankPort;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tankExternalIP;
@property (weak, nonatomic) IBOutlet UITextField *tankExternalPort;


@end

@implementation acAddFishTankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    self.tankNameText.delegate=self;
    self.tankIP.delegate=self;
    self.tankPort.delegate=self;
    self.tankExternalIP.delegate=self;
    self.tankExternalPort.delegate=self;
    [self.scrollView setDelegate:self];
    
    
    
//    CGRect rect = self.scrollView.frame;
  //  rect.size.height = 150;
//    [self.scrollView setFrame: rect];
//    rect = self.scrollView.frame;
//    rect.size.height = 150;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize scrollContentSize = self.scrollView.frame.size;
    scrollContentSize.height +=1;
    //CGSizeMake(320, 745);
    self.scrollView.contentSize = scrollContentSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // empty invalid text fileds to avoid alerts in textFieldShouldEndEditing
    if(![self isIPValid:self.tankIP.text])
        self.tankIP.text = @"";
    if(![self isPortValid:self.tankPort.text])
        self.tankPort.text = @"";
    if(![self isIPValid:self.tankExternalIP.text])
        self.tankExternalIP.text = @"";
    if(![self isPortValid:self.tankExternalPort.text])
        self.tankExternalPort.text = @"";
    
    if (sender != self.doneButton)
        return;
    if (self.tankNameText.text.length > 0) {
        self.fishTank = [[acFishTank alloc] init];
        self.fishTank.name = self.tankNameText.text;
        self.fishTank.tankIP = self.tankIP.text;
        self.fishTank.tankPort = self.tankPort.text;
        self.fishTank.tankExternalIP = self.tankExternalIP.text;
        self.fishTank.tankExternalPort	 = self.tankExternalPort.text;
    }
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint bottomPoint = activeField.frame.origin;
    bottomPoint.y += activeField.frame.size.height;
    bottomPoint.y -= self.scrollView.contentOffset.y;
    float shift = bottomPoint.y-aRect.size.height;
    CGPoint scrollPoint = CGPointMake(0.0, self.scrollView.contentOffset.y+shift+10);
    if (!CGRectContainsPoint(aRect, bottomPoint) ) {
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if([textField.text isEqual: @""])
    {
        return YES;
    }
    if ((textField == self.tankIP) || (textField == self.tankExternalIP))
    {
        if (![self isIPValid:textField.text]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid IP address"
                                                         message:@"Please enter valid IP address"
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    if ((textField == self.tankPort) || (textField == self.tankExternalPort))
    {
        if (![self isPortValid:textField.text]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid port number"
                                                         message:@"Please enter port number from 0 to 65535"
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    
    return YES;
}
- (bool)isIPValid:(NSString*) str {
    if (str)
    {
    struct in_addr dst;
    if (inet_pton(AF_INET, str.UTF8String, &dst) != 1) return false;
    }
    return true;

}
- (bool)isPortValid:(NSString*) str {
    if(str)
    {
    NSInteger port = str.integerValue;
    if (port<0 || port>65535 ) return false;
    }
    return true;
}
@end
