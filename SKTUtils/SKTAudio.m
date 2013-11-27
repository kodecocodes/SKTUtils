/*
 * Copyright (c) 2013 Razeware LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

@import AVFoundation;

#import "SKTAudio.h"

@interface SKTAudio ()
@property (nonatomic, strong) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic, strong) AVAudioPlayer *soundEffectPlayer;
@end

@implementation SKTAudio

+ (instancetype)sharedInstance {
  static dispatch_once_t pred;
  static SKTAudio *sharedInstance;
  dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
  return sharedInstance;
}

- (void)playBackgroundMusic:(NSString *)filename {
  NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  if (url == nil) {
    NSLog(@"Could not find file: %@", filename);
    return;
  }

  NSError *error;
  self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  if (self.backgroundMusicPlayer == nil) {
    NSLog(@"Could not create audio player: %@", error);
	return;
  }

  self.backgroundMusicPlayer.numberOfLoops = -1;
  [self.backgroundMusicPlayer prepareToPlay];
  [self.backgroundMusicPlayer play];
}

- (void)pauseBackgroundMusic {
  if (self.backgroundMusicPlayer.playing) {
    [self.backgroundMusicPlayer pause];
  }
}

- (void)resumeBackgroundMusic {
  if (!self.backgroundMusicPlayer.playing) {
    [self.backgroundMusicPlayer play];
  }
}

- (void)playSoundEffect:(NSString *)filename {
  NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  if (url == nil) {
    NSLog(@"Could not find file: %@", filename);
    return;
  }

  NSError *error;
  self.soundEffectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  if (self.soundEffectPlayer == nil) {
    NSLog(@"Could not create audio player: %@", error);
	return;
  }

  self.soundEffectPlayer.numberOfLoops = 0;
  [self.soundEffectPlayer prepareToPlay];
  [self.soundEffectPlayer play];
}

@end
