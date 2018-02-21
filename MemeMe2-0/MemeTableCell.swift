//
//  MemeTableCell.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {
    var meme: Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    override func prepareForReuse() {
        if let passedMeme = meme, let image = passedMeme.memedImage, let top = passedMeme.topText, let bottom = passedMeme.bottomText {
            memeImageView.image = image
            memeTextLabel.text = top + " " + bottom
        }
    }
}
