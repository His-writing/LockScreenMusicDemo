//
//  ViewController.m
//  LockScreenMusicDemo
//
//  Created by shuzhenguo on 2017/3/24.
//  Copyright © 2017年 shuzhenguo. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()
{
    AVPlayer *_player;
    BOOL _isPlayingNow;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    设置后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

}



- (IBAction)clickPlay:(id)sender {
    
    //    设置播放器
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"那些花儿" ofType:@"mp3"] ];
    _player = [[AVPlayer alloc] initWithURL:url];
    [_player play];
    _isPlayingNow = YES;
    
    
    //后台播放显示信息设置
    [self setPlayingInfo];

}

#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
                //播放
            case  UIEventSubtypeRemoteControlPlay:
                if (!_isPlayingNow) {
                    [_player play];
                }
                _isPlayingNow = !_isPlayingNow;
                break;
                //暂停
            case UIEventSubtypeRemoteControlPause:
                if (_isPlayingNow) {
                    [_player pause];
                }
                _isPlayingNow = !_isPlayingNow;
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}


- (void)setPlayingInfo {
    
    
    
//    AVPlayerItem *playerItem = _player.currentItem;

    // 获取音乐播放信息中心
    MPNowPlayingInfoCenter *nowPlayingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 创建可变字典存放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 获取当前正在播放的音乐对象
//    WPFMusic *music = self.musics[self.currentMusicIndex];
    
//    WPFPlayManager *playManager = [WPFPlayManager sharedPlayManager];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"专辑名称";
    // 歌手
    info[MPMediaItemPropertyArtist] = @"歌手";
    // 专辑图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"pushu.jpg"]];
    
    //当前播放的时间
//    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(1);
    // 音乐总时间
    info[MPMediaItemPropertyPlaybackDuration] = @(295);
    
    //进度光标的速度 （这个随 自己的播放速率调整，我默认是原速播放）
    info[MPNowPlayingInfoPropertyPlaybackRate] = @(1);


    // 音乐名称
    info[MPMediaItemPropertyTitle] = @"音乐名称";
    
    nowPlayingInfoCenter.nowPlayingInfo = info;

}



-(void)ThecustomUpdateLockScreen{
    
//    点击按钮开始播放，注意因为MPNowPlayingInfoCenter只支持5.0+所以为了防止低版本使用巧妙的应用了NSClassFromString进行了判断
    //更新锁屏时的歌曲信息
    if (NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_0) {
            MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
            [commandCenter.changePlaybackPositionCommand setEnabled:true];
            [commandCenter.changePlaybackPositionCommand addTarget:self action:@selector(changedThumbSliderOnLockScreen:)];
            [commandCenter.pauseCommand addTarget:self action:@selector(pauseCommandScreen)];
            [commandCenter.playCommand addTarget:self action:@selector(pauseCommandScreen)];
            [commandCenter.stopCommand addTarget:self action:@selector(pauseCommandScreen)];
            [commandCenter.nextTrackCommand addTarget:self action:@selector(nextTrackCommandScreen)];
            [commandCenter.previousTrackCommand addTarget:self action:@selector(previousTrackCommandScreen)];
        }
        [self setPlayingInfo];
    }
    
    
}


-(void)pauseCommandScreen{}
-(void)nextTrackCommandScreen{}
-(void)previousTrackCommandScreen{}


- (MPRemoteCommandHandlerStatus)changedThumbSliderOnLockScreen:(MPChangePlaybackPositionCommandEvent *)event
{
    NSLog(@"%f",event.positionTime);
    
    
//    [[SZGVideoPlayerController getInstanceVideoPlayer] setCurrentPlaybackTime:floor(event.positionTime)];

    NSLog(@"这个event.positionTime赋给");
    
    
//    _player
    
//    WPFPlayManager *pm = [WPFPlayManager sharedPlayManager];
//    pm.currentTime = event.positionTime ;
    
    [self setPlayingInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}




- (void)viewDidAppear:(BOOL)animated {
    //    接受远程控制
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    //    取消远程控制
    [self resignFirstResponder];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
