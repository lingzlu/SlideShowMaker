//
//  ViewController.swift
//  SlideShowMaker
//
//  Created by cf-L on 08/22/2017.
//  Copyright (c) 2017 cf-L. All rights reserved.
//

import UIKit
import SlideShowMaker
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func makeVideo() {
        
        let images = [
            #imageLiteral(resourceName: "image1"),
            #imageLiteral(resourceName: "image2"),
            #imageLiteral(resourceName: "image3"),
            #imageLiteral(resourceName: "image4"),
            #imageLiteral(resourceName: "image5"),
        ]

        var assets: [PhotoAsset] = images.map { .photo($0) }


        let livePhotosName = ["livePhoto1",
                              "livePhoto2",
                              "livePhoto3",
                              "livePhoto4",
                              "livePhoto5",
                              "livePhoto6"]

        livePhotosName.forEach { fileName in
            if let videoUrl = Bundle.main.url(forResource: fileName, withExtension: "mov") {
                let videoAsset = AVURLAsset(url: videoUrl)
                assets.append(.video(videoAsset))
            }
        }

        var audio: AVURLAsset?
        var timeRange: CMTimeRange?
        if let audioURL = Bundle.main.url(forResource: "chill", withExtension: "mp4") {
            audio = AVURLAsset(url: audioURL)
            let audioDuration = CMTime(seconds: 30, preferredTimescale: audio!.duration.timescale)
            timeRange = CMTimeRange(start: kCMTimeZero, duration: audioDuration)
        }

        let maker = VideoMaker(assets: assets)
        maker.makeVideo(audioAsset: audio!) { success, videoUrl in
            if let url = videoUrl {
                print(url)  // /Library/Mov/merge.mov
                self.playVideo(videoUrl: url)
            }
        }

        // OR: VideoMaker(images: images, movement: ImageMovement.fade)
//        let maker = VideoMaker(assets: assets, movement: ImageMovement.fade)
//
//        maker.contentMode = .scaleAspectFill

//        maker.exportVideo(audio: audio, audioTimeRange: timeRange, completed: { success, videoURL in
//            if let url = videoURL {
//                print(url)  // /Library/Mov/merge.mov
//                self.playVideo(videoUrl: url)
//            }
//
//        }).progress = { progress in
//            print(progress)
//        }
    }

    private func playVideo(videoUrl: URL) {
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

