//
//  EditImageController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/11/20.
//

import UIKit

class EditImageController: UIViewController {
    
    deinit {
        print("Freeing memory from Edit Image Controller")
    }
    
    let context = CIContext()
    var image: Image!
    var newImage: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var popUp: UIView!
    @IBOutlet var editBar: UIToolbar!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var cropButton: UIBarButtonItem!
    @IBOutlet var filterPicker: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.backgroundColor = .systemFill
        filterPicker.isHidden = true
        
        if image != nil {
            popUp.isHidden = true
            imageView.image = UIImage(data: image!.image)
            
        } else {
            editBar.isHidden = true
            popUp.layer.cornerRadius = 10.0
            popUp.isHidden = false
        }
    }
    
    @IBAction func filter() {
        filterPicker.isHidden = false
    }
    
    @IBAction func crop() {
        print("crop image")
    }
    
//    @IBAction func editImage() {
//        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        ac.addAction(UIAlertAction(title: "Sepia Tone", style: .default, handler: {[weak self] _ in
//            print("adding Sepia")
//            if self!.image == nil {
//                self?.imageView.image = Filters.main.sepiaTone(value: 1.0, image: self?.newImage, context: self!.context)
//            } else {
//                self?.imageView.image = Filters.main.sepiaTone(value: 1.0, image: UIImage(data: self!.image.image), context: self!.context)
//            }
//        }))
//        ac.addAction(UIAlertAction(title: "Noir", style: .default, handler: {[weak self] _ in
//            print("Noir")
//            if self!.image == nil {
//                self?.imageView.image = Filters.main.noir(image: self?.newImage, context: self!.context)
//            } else {
//                self?.imageView.image = Filters.main.noir(image: UIImage(data: self!.image.image), context: self!.context)
//            }
//        }))
//        ac.addAction(UIAlertAction(title: "Invert", style: .default, handler: {[weak self] _ in
//            print("inverted")
//            if self!.image == nil {
//                self?.imageView.image = Filters.main.invert(image: self?.newImage, context: self!.context)
//            } else {
//                self?.imageView.image = Filters.main.invert(image: UIImage(data: (self?.image.image)!), context: self!.context)
//            }
//        }))
//        ac.addAction(UIAlertAction(title: "Grey Scale", style: .default, handler: {[weak self] _ in
//            print("Grey scaled")
//            if self!.image == nil {
//                self?.imageView.image = Filters.main.greyScale(value: 1.0, image: self?.newImage, context: self!.context)
//            } else {
//                self?.imageView.image = Filters.main.greyScale(value: 1.0, image: UIImage(data: (self?.image.image)!), context: self!.context)
//            }
//        }))
//        ac.addAction(UIAlertAction(title: "Vintage", style: .default, handler: {[weak self] _ in
//            print("vintage")
//            if self?.image == nil {
//                self?.imageView.image = Filters.main.vintage(image: self?.newImage, context: self!.context)
//            } else {
//                self?.imageView.image = Filters.main.vintage(image: UIImage(data: (self?.image.image)!), context: self!.context)
//            }
//        }))
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
//            print("canceled")
//        }))
//        present(ac, animated: true, completion: nil)
//    }

    @IBAction func openCamera() {
        popUp.isHidden = true
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true) {
            self.editBar.isHidden = false
        }
    }
    
    @IBAction func openPhotos() {
        popUp.isHidden = true
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true) {
            self.editBar.isHidden = false
        }
    }
    
    @IBAction func saveImage() {
        if imageView.image != nil {
            
            if image != nil {
                image.image = (imageView.image?.fixOrientation().pngData())!
                if ImageManager.main.update(image: image) > 0 {
                    let alert = UIAlertController(title: "Image Updated!", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            } else {
                let updatedImg = Image(id: -1, image: (imageView.image?.fixOrientation().pngData())!, date: Date())
                
                if ImageManager.main.create(image: updatedImg) > 0 {
                    let alert = UIAlertController(title: "Image Saved", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
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
        picker.dismiss(animated: true, completion: {
            self.editBar.isHidden = true
            self.popUp.isHidden = false
        })
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
