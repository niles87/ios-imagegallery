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
        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopUpView") as! ViewController
        self.addChild(popUpView)
        
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMove(toParent: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath as IndexPath)
        let img = UIImage(data: images[indexPath.item].image)
        let imageView = UIImageView()
        imageView.image = img
        cell.contentView.addSubview(imageView)
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
        }
    }
    
    func reload() {
        images = ImageManager.main.getAllImages()
        self.collectionView.reloadData()
    }
    
}
