//
//  DetailViewController.h
//  Cats
//
//  Created by Bennett on 2018-08-16.
//  Copyright © 2018 Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "Photo.h"

@interface DetailViewController : UIViewController <SFSafariViewControllerDelegate>
@property (nonatomic, strong) Photo* photo;
@end
