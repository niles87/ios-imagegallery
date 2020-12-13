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
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    @IBAction func openCameraOrImage() {
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(respondToPress))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath as IndexPath)
        let img = UIImage(data: images[indexPath.item].image)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = img
        cell.layer.cornerRadius = 5.0
        cell.contentView.addSubview(imageView)
        cell.addGestureRecognizer(longPress)
        cell.tag = indexPath.item
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected \(indexPath.item)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickedFromGallerySegue" {
            if let cell = sender as? UICollectionViewCell,
               let indexPath = self.collectionView.indexPath(for: cell) {
                if let destination = segue.destination as? EditImageController {
                    destination.image = images[indexPath.item]
                }
            }
        } else if segue.identifier == "CreateImageSegue" {
            if segue.destination is EditImageController {
                
            }
        }
    }
    
    @objc func respondToPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UILongPressGestureRecognizer.State.ended {
            // todo create a popup menu on cell to delete image from db and collection view
            print("respond to press", sender.view!.tag)
            if ImageManager.main.delete(image: images[sender.view!.tag]) {
                reload()
            }
        }
    }
    
    // Update Images list and reload
    func reload() {
        images = ImageManager.main.getAllImages()
        self.collectionView.reloadData()
    }
    
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    // Set Size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
