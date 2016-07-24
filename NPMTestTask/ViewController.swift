//
//  ViewController.swift
//  NPMTestTask
//
//  Created by Mikhail Zhadko on 7/22/16.
//  Copyright © 2016 Mikhail Zhadko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var imagesArray: [String]!
    var refreshControl:UIRefreshControl!
    func loadData() {
        imagesArray = ["http://i.dailymail.co.uk/i/pix/2016/03/22/13/32738A6E00000578-3504412-image-a-6_1458654517341.jpg",
                           "https://upload.wikimedia.org/wikipedia/commons/0/01/Macintosh_Classic_2.jpg",
                           "http://7606-presscdn-0-74.pagely.netdna-cdn.com/wp-content/uploads/2016/03/Dubai-Photos-Images-Travel-Tourist-Images-Pictures-800x600.jpg",
                           "https://upload.wikimedia.org/wikipedia/commons/0/01/Macintosh_Classic_2.jpg",
                           "http://i.dailymail.co.uk/i/pix/2016/03/22/13/32738A6E00000578-3504412-image-a-6_1458654517341.jpg",
                           "https://upload.wikimedia.org/wikipedia/commons/0/01/Macintosh_Classic_2.jpg"]
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        collectionView.alwaysBounceVertical = true
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)),   forControlEvents: UIControlEvents.ValueChanged)
        collectionView.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func refresh(sender: AnyObject) {
        loadData()
        collectionView.reloadData()
        refreshControl.endRefreshing()
        
    }
    //MARK: - COLLECTION VIEW DELEGATE / DATA SOURCE
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.image.downloadedFrom(imagesArray[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.imagesArray.removeAtIndex(indexPath.row)
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            
            }) { (true) in
               
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 10, height: self.view.frame.width - 10)
    }
    
    //MARK: - Other
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ (context) in
            self.collectionView.collectionViewLayout.invalidateLayout()
            }) { (context) in
                self.collectionView.reloadData()
        }
        
    }

}

extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .ScaleAspectFill) {
        guard let url = NSURL(string: link) else { return }
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue(), { 
                self.image = image
            })
            }.resume()
    }
}
