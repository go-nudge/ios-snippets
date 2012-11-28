//
//  MasterViewController.h
//  DataPickerExample
//
//  Created by Jose on 28.11.12.
//  Copyright (c) 2012 Nudge GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NudgeDataPickerController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <NudgeDataPickerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
