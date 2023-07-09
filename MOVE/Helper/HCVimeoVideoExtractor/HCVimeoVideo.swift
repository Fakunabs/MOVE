//
//  HCVimeoVideo.swift
//  MOVE
//
//  Created by Vinh Nguyen on 08/06/2023.
//

import UIKit

public enum HCVimeoThumbnailQuality: String {
    case quality640 = "640"
    case quality960 = "960"
    case quality1280 = "1280"
    case qualityBase = "base"
    case qualityUnknown = "unknown"
}

public enum HCVimeoVideoQuality: String {
    case quality360p = "360p"
    case quality540p = "540p"
    case quality640p = "640p"
    case quality720p = "720p"
    case quality960p = "960p"
    case quality1080p = "1080p"
    case qualityUnknown = "unknown"
}

public class HCVimeoVideo: NSObject {
    public var title = ""
    public var thumbnailURL = [HCVimeoThumbnailQuality: URL]()
    public var videoURL = [HCVimeoVideoQuality: URL]()
}
