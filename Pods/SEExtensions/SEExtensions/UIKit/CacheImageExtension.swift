//
//  CacheImageExtension.swift
//  GPFireable_Example
//
//  Created by Conver on 5/27/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Kingfisher

public extension UIImageView {

    @discardableResult
    func url(_ urlString: String?,
             placeholderImage: UIImage? = nil) -> Self {
        return url(URL(string: urlString ?? ""),
                   placeholderImage: placeholderImage)
    }

    @discardableResult
    func url(_ url: URL?,
             completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> Self {
        self.url(url,
                 placeholderImage: nil,
                 transition: ImageTransition.fade(0.3),
                 completion: completion)
        return self
    }

    @discardableResult
    func url(_ url: URL?,
             placeholderImage: UIImage? = nil,
             transition: ImageTransition = ImageTransition.fade(0.3),
             completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> Self {
        kf.indicatorType = .activity
        backgroundColor(Color(hexString: "#BABABA")!)
        kf.setImage(with: url,
                    placeholder: placeholderImage,
                    options: [.transition(transition)],
                    progressBlock: nil) { result in
            completion?(result)
        }
        return self
    }
}
