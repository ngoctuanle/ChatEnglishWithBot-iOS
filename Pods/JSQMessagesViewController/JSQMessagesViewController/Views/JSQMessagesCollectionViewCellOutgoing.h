//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesCollectionViewCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

/**
 *  A `JSQMessagesCollectionViewCellOutgoing` object is a concrete instance 
 *  of `JSQMessagesCollectionViewCell` that represents an outgoing message data item.
 */
@interface JSQMessagesCollectionViewCellOutgoing : JSQMessagesCollectionViewCell
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *pro5view;

@end
