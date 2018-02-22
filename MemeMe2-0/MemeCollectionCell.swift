//
//  MemeCollectionCell.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {
    var meme: Meme?
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func prepareForReuse() {
        if let passedMeme = meme, let image = passedMeme.memedImage {
            self.memeImageView.image = image
           
        }
    }
}
