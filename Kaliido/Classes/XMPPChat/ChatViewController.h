//
//  KLChatViewController.h
//  Kaliido
//
//  Created by Learco R on 6/6/16.
//  Copyright © 2016 Kaliido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TURNSocket.h"
#import "KLPlaceholderTextView.h"
#import "ChatMapViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,ChatMapViewtDelegate> {
    
    KLPlaceholderTextView		*messageField;
//    NSString		*chatWithUser;
    UITableView		*tView;
    NSMutableArray	*messages;
    KLMessageType   selectedType;
    NSString* fileUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic,retain) IBOutlet KLPlaceholderTextView *messageField;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) IBOutlet UITableView *buddyChatTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToBottom;

@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayer;
- (IBAction) sendMessage;
- (IBAction) closeChat;

@end

