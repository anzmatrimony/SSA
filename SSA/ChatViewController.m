//
//  ChatViewController.m
//  ChatApp
//
//  Created by Sunera on 6/23/17.
//  Copyright © 2017 ebutor. All rights reserved.
//

#import "ChatViewController.h"
#import "Firebase.h"
#import "JSQMessagesAvatarImageFactory.h"

@interface ChatViewController ()
{
    FIRDatabaseReference *kidRef;
    FIRDatabaseReference *messagesRef, *messagesRef1;
    FIRDatabaseHandle newMessageHandle,messagesListHandle;
    BOOL newMessagesOnTop;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    kidRef = [[[[FIRDatabase database] reference] child:@"Kids"] child:self.kidId];
    messagesRef = [kidRef child:@"messages"];
    messages = [[NSMutableArray alloc] init];
    
    
    
    self.showLoadEarlierMessagesHeader = YES;
    
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    
    
    /**
     *  OPT-IN: allow cells to be deleted
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
    //[self observeMessages];
    
    // Decide whether or not to reverse the messages
    newMessagesOnTop = NO;
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [messagesRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        
        NSDictionary *postDict = snapshot.value;
        if ([postDict isEqual:[NSNull null]]) {
            return ;
        }
        
        if ([postDict objectForKey:@"text"] != nil && [[postDict objectForKey:@"text"] length] != 0) {
            JSQMessage *message = [[JSQMessage alloc] initWithSenderId:[postDict objectForKey:@"senderId"]
                                                     senderDisplayName:[postDict objectForKey:@"senderName"]
                                                                  date:[NSDate date]
                                                                  text:[postDict objectForKey:@"text"]];
            if (newMessagesOnTop) {
                [messages insertObject:message atIndex:0];
            } else {
                [messages addObject:message];
            }
            
            
        }
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            //[self.tableView reloadData];
            [self finishReceivingMessage];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [messagesRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        
        [self finishReceivingMessage];
        initialAdds = NO;
    }];
    
    messagesRef1 = [kidRef child:@"messages"];
    [[[messagesRef1 queryOrderedByChild:@"status"] queryEqualToValue:@"sent"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapShot1){
        NSLog(@"sent messages : %@",snapShot1.value);
        if (snapShot1.value != nil && ![snapShot1.value isEqual:[NSNull null]]) {
            NSDictionary *mesgDict = snapShot1.value;
            for (NSString *key in [mesgDict allKeys]) {
                NSDictionary *dict = [mesgDict objectForKey:key];
                if (![self.senderId isEqualToString:[dict objectForKey:@"senderId"]]) {
                    FIRDatabaseReference *particularMessagesRef1 = [messagesRef1 child:key];
                    [particularMessagesRef1 updateChildValues:@{@"status" : @"seen"}];
                }
            }
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = false;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [messagesRef removeAllObservers];
    [messagesRef1 removeAllObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [messagesRef removeObserverWithHandle:newMessageHandle];
    [messagesRef removeObserverWithHandle:messagesListHandle];
}

- (void)observeMessages{
    FIRDatabaseQuery *messageQuery = [messagesRef queryLimitedToLast:25];
    
    messagesListHandle = [messageQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        if ([postDict isEqual:[NSNull null]]) {
            return ;
        }
        NSArray *allKeys = [postDict allKeys];
        if (allKeys.count > 0) {
            [messages removeAllObjects];
            for (NSString *key in allKeys) {
                NSDictionary *dataDict = [postDict objectForKey:key];
                if ([dataDict objectForKey:@"text"] != nil && [[dataDict objectForKey:@"text"] length] != 0) {
                    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:[dataDict objectForKey:@"senderId"]
                                                             senderDisplayName:[dataDict objectForKey:@"senderName"]
                                                                          date:[NSDate date]
                                                                          text:[dataDict objectForKey:@"text"]];
                    [messages addObject:message];
                }
            }
            [self finishReceivingMessage];
        }
        
    }];
    
    newMessageHandle = [messageQuery observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postDict = snapshot.value;
        if ([postDict isEqual:[NSNull null]]) {
            return ;
        }
        
                if ([postDict objectForKey:@"text"] != nil && [[postDict objectForKey:@"text"] length] != 0) {
                    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:[postDict objectForKey:@"senderId"]
                                                             senderDisplayName:[postDict objectForKey:@"senderName"]
                                                                          date:[NSDate date]
                                                                          text:[postDict objectForKey:@"text"]];
                    [messages addObject:message];
                    
                }
        
            [self finishReceivingMessage];
        
        
    }];
    // 2. We can use the observe method to listen for new
    // messages being written to the Firebase DB
    /*newMessageHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
        // 3
        let messageData = snapshot.value as! Dictionary<String, String>
        
        if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
            // 4
            self.addMessage(withId: id, name: name, text: text)
            
            // 5
            self.finishReceivingMessage()
        } else {
            print("Error! Could not decode message data")
        }
    })*/
}

- (NSString *)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];

    return dateString;
}
#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    FIRDatabaseReference *mesageItemRef = [messagesRef childByAutoId];
    [mesageItemRef setValue:@{@"senderId":senderId, @"senderName":senderDisplayName, @"text":text, @"status":@"sent"}];
    /*JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    
    [messages addObject:message];*/
    
    [self finishSendingMessageAnimated:YES];
}


#pragma mark - JSQMessages CollectionView DataSource


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    JSQMessagesBubbleImage *outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    JSQMessagesBubbleImage *incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return outgoingBubbleImageData;
    }
    
    return incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    
    JSQMessagesAvatarImage *jobsImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"demo_avatar_jobs"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
    return jobsImage;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    /*if (indexPath.item % 3 == 0) {
        JSQMessage *message = [messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }*/
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    //cell.accessoryButton.hidden = ![self shouldShowAccessoryButtonForMessage:msg];
    
    return cell;
}

/*- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return ([message isMediaMessage] && [NSUserDefaults accessoryButtonForMediaMessages]);
}*/


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}
//
//-(CGSize)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if ( you-have-a-cell-at-the-row-for-this-section )
//        return myNormalHeaderSize;
//    else return CGSizeMake( 0,0 );
//}


#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}

@end
