//
//  CollectionViewController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/7/20.
//

import UIKit

class CollectionController: UICollectionViewController {
    
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image", for: indexPath as IndexPath)
        let img = UIImage(data: images[indexPath.item].image)
        let imageView = UIImageView()
        imageView.image = img
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
    }
    
    func reload() {
        images = ImageManager.main.getAllImages()
        self.collectionView.reloadData()
    }
}
