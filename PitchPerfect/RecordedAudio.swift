//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Keng Siang Lee on 15/3/15.
//  Copyright (c) 2015 KSL. All rights reserved.
//

import Foundation

//Model class for user-recorded audio
class RecordedAudio : NSObject {
    
    //path to url of the recorded file
    var filePathUrl: NSURL!
    
    //title of the file
    var title: String!
    
    //initializer
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}