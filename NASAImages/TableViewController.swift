//
//  TableViewController.swift
//  PicturesFromMars
//
//  Created by Juan Catalan on 3/26/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import MBProgressHUD

class TableViewController: UITableViewController {

    let maxNumberOfImages = 25
    static let downloader = ImageDownloader()
    var imageInfo: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.addTarget(self, action: #selector(getPictureInfo), for: .valueChanged)
        getPictureInfo()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NASAImageTableViewCell", for: indexPath) as! NASAImageTableViewCell
        cell.configureFrom(imageInfo[indexPath.row])
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let cell = sender as! NASAImageTableViewCell
        destination.image = cell.NASAImageView.image
        destination.title = cell.NASATitleLabel.text
        destination.text = cell.explanationLabel.text
    }
    
    // MARK: - Image download
    
    func getPictureInfo() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Downloading..."
        DispatchQueue.global().async {
            let date = Date()
            let dispatchGroup = DispatchGroup()
            for day in 0..<self.maxNumberOfImages {
                let dateStr = self.dateString(Calendar.current.date(byAdding: .day, value: -day, to: date)!)
                let url = URL(string: "https://api.nasa.gov/planetary/apod")!
                let parameters = ["api_key": "XDPoPavubk3br8Gz5RFHbu4BgM0gy5sUDJNImvU1", "date": dateStr]
                dispatchGroup.enter()
                Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
                    .responseJSON { response in
                        if let result = response.result.value {
                            let json = JSON(result)
                            let mediaType = json["media_type"].string!
                            if (mediaType == "image") {
                                self.imageInfo.append(json)
                            }
                        }
                        dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()
            DispatchQueue.main.async {
                hud.hide(animated: true);
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func dateString(_ date: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        return "\(components.year!)-\(components.month!)-\(components.day!)"
    }

}
