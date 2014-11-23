//
//  ViewController.m
//  Chat
//
//  Created by Jorge Maroto García on 20/11/14.
//  Copyright (c) 2014 http://maroto.me. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"


@interface ViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) AppDelegate *appdelegate;
@property (nonatomic, strong) NSMutableArray *msgs;

@property (nonatomic, strong) MCBrowserViewController *browser;


@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.msgs = [NSMutableArray array];
    
    self.appdelegate.session.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self requireDeviceConnected];
}

- (IBAction)sendMsg:(UIButton *)sender
{
    NSError *error;
    NSData *data = [self.message.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.appdelegate.session sendData:data toPeers:self.appdelegate.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
    [self.tableView reloadData];
}

#pragma mark - Convenience methods
- (void)requireDeviceConnected
{
    if (self.appdelegate.session.connectedPeers.count == 0) {
        self.browser = [[MCBrowserViewController alloc] initWithServiceType:chatService session:self.appdelegate.session];
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
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    msg = [peerID.displayName stringByAppendingFormat:@": %@", msg];
    
    [self.msgs insertObject:msg atIndex:0];

    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{}

#pragma mark - UITableViewDelegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"chatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.textLabel.text = self.msgs[indexPath.row];
    
    return cell;
}

@end
