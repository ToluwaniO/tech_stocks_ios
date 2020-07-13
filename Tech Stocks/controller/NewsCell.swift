//
// Created by Toluwani Ogunsanya on 2020-07-07.
// Copyright (c) 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    @IBOutlet var newsOrg: UILabel!
    @IBOutlet var newsDate: UILabel!
    @IBOutlet var headLine: UILabel!
    @IBOutlet var newsImage: UIImageView!

    func configure(news: News) -> Void {
        newsOrg.text = news.source
        headLine.text = news.headline
        newsDate.text = "1d"
        newsImage.kf.setImage(with: URL(string: news.image))
    }
    

}
