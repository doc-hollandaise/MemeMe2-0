//
//  SentMemesCollectionViewController.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController, Presenter {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    

    var memes = [Meme]() {
        didSet {
            memeCollectionView.reloadData()
            memeCollectionView.collectionViewLayout.invalidateLayout()
            memeCollectionView.layoutIfNeeded()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let layout = (view.frame.size.width - (2 * space)) / 3.0

        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: layout, height: layout)
        
    //    memeCollectionView.register(MemeCollectionCell.self, forCellWithReuseIdentifier: "MemeCollectionCell")
        
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.row]
        cell.meme = meme
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowMemeVC") as? ShowMemeViewController {
            vc.memedImage = meme.memedImage
            
           navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   
    @IBAction func createMeme(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMemeVC") as? CreateMemeViewController {
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func reload() {
        updateMemes()
    }
    
    func updateMemes() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    func dismiss() {
        if let vc = navigationController?.presentedViewController {
            vc.dismiss(animated: true, completion: {
                self.reload()
            })
        }
    }
}
