//
//  DetailViewController.swift
//  NASAImages
//
//  Created by Juan Catalan on 3/26/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!

    var image: UIImage?
    var text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        textView.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
