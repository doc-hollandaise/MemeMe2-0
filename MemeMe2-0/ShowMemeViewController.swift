//
//  ShowMemeViewController.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit
import Foundation
class ShowMemeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var memedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let memeImage = memedImage {
            imageView.image = memeImage
        }
    }
    
}
