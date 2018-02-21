//
//  SentMemesViewController.swift
//  MemeMe2-0
//
//  Created by Derek Justus on 2/8/18.
//  Copyright © 2018 Derek Justus. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, Presenter {
    
    
    
    var memes = [Meme]() {
        didSet {
              self.memeTableView.reloadData()
        }
    }
    

    @IBOutlet var memeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        memeTableView.register(MemeTableCell.self, forCellReuseIdentifier: "MemeTableView")
        
        updateMemes()
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
