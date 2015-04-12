//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Shahbaz Javeed on 4/8/15.
//  Copyright (c) 2015 Shahbaz Javeed. All rights reserved.
//

import Foundation
import AVFoundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
    func audioFile() ->AVAudioFile! {
        return AVAudioFile(forReading: filePathUrl, error: nil)
    }
}