//
//  SentMemesViewController.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, Presenter {
    @IBOutlet var memeTableView: UITableView!
    
    
    var memes = [Meme]() {
        didSet {
              self.memeTableView.reloadData()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()       
    
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableCell
        let meme = memes[indexPath.row]
        cell.meme = meme
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
