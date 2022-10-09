//
//  ViewController.m
//  TestGameKitBlueTooth
//
//  Created by beforeold on 2022/10/9.
//

#import "ViewController.h"

@import GameKit;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface ViewController () <GKPeerPickerControllerDelegate>

@property (nonatomic, strong) GKSession *session;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)connect {
    __auto_type controller = [[GKPeerPickerController alloc] init];
    controller.delegate = self;
    [controller show];
}

- (void)sendData {
    __auto_type data = [NSData data];
    NSError *outError = nil;
    [self.session sendDataToAllPeers:data
                        withDataMode:GKSendDataReliable
                               error:&outError];
}

// MARK: - callback
/// to receive data callback, set by the session -setDataReceiveHandler:context
- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peekId
          inSession:(GKSession *)session
            context:(void *)context {
    NSLog(@"did receive data");
}

// MARK: - delegate
- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *)session {
    self.session = session;
    
    // set receive handler
    [self.session setDataReceiveHandler:self
                            withContext:nil];
}


@end

#pragma clang diagnostic pop
