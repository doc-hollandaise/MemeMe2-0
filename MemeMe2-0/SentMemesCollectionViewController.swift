//
//  SentMemesCollectionViewController.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let layoutWidth = (view.frame.size.width - (2 * space)) / 3.0
        let layoutHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: layoutWidth, height: layoutHeight)
    }
}
