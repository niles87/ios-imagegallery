//
//  EditImageController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/11/20.
//

import UIKit

class EditImageController: UIViewController {
    var image: Image!
    var newImage: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var popUp: UIView!
    @IBOutlet var edit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edit.layer.cornerRadius = 10.0
        popUp.backgroundColor = .systemFill
        
        if image != nil {
            popUp.isHidden = true
            imageView.image = UIImage(data: image!.image)
            
        } else {
            edit.isHidden = true
            popUp.layer.cornerRadius = 10.0
            popUp.isHidden = false
        }
    }

    @IBAction func openCamera() {
        popUp.isHidden = true
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        edit.isHidden = false
    }
    
    @IBAction func openPhotos() {
        popUp.isHidden = true
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        edit.isHidden = false
    }
    
    @IBAction func saveImage() {
        if imageView.image != nil {
            
            if image != nil {
                image.image = (imageView.image?.pngData()!)!
                if ImageManager.main.update(image: image) > 0 {
                    print("updated image")
                }
            } else {
                let updatedImg = Image(id: -1, image: (imageView.image?.pngData()!)!, date: Date())
                
                if ImageManager.main.create(image: updatedImg) > 0 {
                    print("new image saved!!")
                }
            }
        }
    }
    
    @objc func image(_: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Saved Image!", message: "Altered image has been saved to photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}

extension EditImageController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        newImage = photo
        imageView.image = photo
    }
}
