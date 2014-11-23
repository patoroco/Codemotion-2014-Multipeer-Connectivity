//
//  ViewController.m
//  SharePhotos
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) AppDelegate *appdelegate;
@property (nonatomic, strong) MCBrowserViewController *browser;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (nonatomic, strong) NSURL *imageURL;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appdelegate = [[UIApplication sharedApplication] delegate];
    self.appdelegate.session.delegate = self;
}

- (IBAction)choosePhoto:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)sendPhoto:(UIButton *)sender
{
    if (self.appdelegate.session.connectedPeers.count == 0) {
        [self requireDeviceConnected];
        return;
    }

    if (self.imageURL == nil) return;
    
    MCSession *session = self.appdelegate.session;
    MCPeerID *peer = session.connectedPeers[0];
    
    [session sendResourceAtURL:self.imageURL withName:@"pic"
                        toPeer:peer withCompletionHandler:^(NSError *error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.picture.image = nil;
                                self.picture.backgroundColor = error ?
                                                                [UIColor redColor] :
                                                                [UIColor greenColor];
                            });
                        }];
}


#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    NSData *jpegImg = UIImageJPEGRepresentation(selectedImage, 0.5);
    
    NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingString:@"pic.jpg"];
    self.imageURL = [NSURL fileURLWithPath:tmpPath];
    
    [jpegImg writeToURL:self.imageURL atomically:NO];
    
    self.picture.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Convenience methods
- (void)requireDeviceConnected
{
    if (self.appdelegate.session.connectedPeers.count == 0) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:sharePicsService session:self.appdelegate.session];
        self.browser.delegate = self;
        [self presentViewController:self.browser animated:YES completion:nil];
    }
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:^{ [self requireDeviceConnected]; }];
}

#pragma mark - MCSessionDelegate
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.picture.image = nil;
        self.picture.backgroundColor = [UIColor yellowColor];
    });
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName
       fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:localURL]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.picture.image = image;
    });
}


- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{}
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}
@end