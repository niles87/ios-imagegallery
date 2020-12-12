//
//  EditImageController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/11/20.
//

import UIKit

class EditImageController: UIViewController {
    var image: Image?
    var otherImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image != nil {
            imageView.image = UIImage(data: image!.image)
        } else {
            imageView.image = otherImage
        }
    }

    @IBAction func didTapButton() {

    }
}

