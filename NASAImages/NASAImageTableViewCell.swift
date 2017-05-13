//
//  NASAImageTableViewCell.swift
//  PicturesFromMars
//
//  Created by Juan Catalan on 3/26/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class NASAImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NASAImageView: UIImageView!
    @IBOutlet weak var NASATitleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    let downloader = TableViewController.downloader

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureFrom(_ json:JSON) {
        let titleText = json["title"].string!
        let explanationText = json["explanation"].string!
        let urlString = json["url"].string!
        
        NASATitleLabel.text = titleText
        explanationLabel.text = explanationText
        
        self.NASAImageView.image = nil;
        let hud = MBProgressHUD.showAdded(to: NASAImageView, animated: true)
        
        let urlRequest = URLRequest(url: URL(string: urlString)!)
        
        downloader.download(urlRequest) { response in
            if let image = response.result.value {
                hud.hide(animated: true)
                self.NASAImageView.image = image
            }
        }
    }
}
