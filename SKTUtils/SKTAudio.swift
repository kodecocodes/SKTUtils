/*
 * Copyright (c) 2013-2014 Razeware LLC
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

import AVFoundation

/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
class SKTAudio {
  var backgroundMusicPlayer: AVAudioPlayer!
  var soundEffectPlayer: AVAudioPlayer!

  class func sharedInstance() -> SKTAudio {
    return SKTAudioInstance
  }

  func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }

    var error: NSError? = nil
    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
      println("Could not create audio player: \(error!)")
      return
    }

    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
  }

  func pauseBackgroundMusic() {
    if backgroundMusicPlayer.playing {
      backgroundMusicPlayer.pause()
    }
  }

  func resumeBackgroundMusic() {
    if !backgroundMusicPlayer.playing {
      backgroundMusicPlayer.play()
    }
  }

  func playSoundEffect(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }

    var error: NSError? = nil
    soundEffectPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if soundEffectPlayer == nil {
      println("Could not create audio player: \(error!)")
      return
    }

    soundEffectPlayer.numberOfLoops = 0
    soundEffectPlayer.prepareToPlay()
    soundEffectPlayer.play()
  }
}

let SKTAudioInstance = SKTAudio()
