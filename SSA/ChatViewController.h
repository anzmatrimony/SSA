//
//  ChatViewController.h
//  ChatApp
//
//  Created by Sunera on 6/23/17.
//  Copyright © 2017 ebutor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController.h"
#import "JSQMessages.h"

@interface ChatViewController : JSQMessagesViewController{
    NSMutableArray *messages;
}

@property (nonatomic, strong) NSString *kidId;
@end
