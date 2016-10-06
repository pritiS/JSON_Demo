//
//  ViewController.h
//  Json_Demo
//
//  Created by Priti Suthar on 5/25/16.
//  Copyright © 2016 Priti Suthar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{

    __weak IBOutlet UITextField *txtUserID;
    __weak IBOutlet UIView *vW;
    __weak IBOutlet UIView *vWAgree;
    __weak IBOutlet UITextView *txtVWLink;
}

- (IBAction)btnGetData:(id)sender;


@end

