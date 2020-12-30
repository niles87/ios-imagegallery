//
//  EditImageController.swift
//  ImageCapture
//
//  Created by Niles Bingham on 12/11/20.
//

import UIKit
import CropViewController

class EditImageController: UIViewController, UIPickerViewDataSource {
    
    deinit {
        print("Freeing memory from Edit Image Controller")
    }
    
    let context = CIContext()
    var image: Image!
    var newImage: UIImage!
    var wheelContent = [ApplyFilter]()
    var intensity = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var colors = ["Grey", "Blue", "Red", "Yellow", "Green", "Orange", "Purple"]
    var pickedFilter = ""
    var pickedIntensity = ""
    var pickedColor = ""
    var orgImg: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var popUp: UIView!
    @IBOutlet var editBar: UIToolbar!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var cropButton: UIBarButtonItem!
    @IBOutlet var filterPicker: UIPickerView!
    @IBOutlet var addFilterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.backgroundColor = .systemFill
        filterPicker.isHidden = true
        addFilterButton.isHidden = true
        addFilterButton.backgroundColor = .secondarySystemBackground
        
        wheelContent.append(ApplyFilter(filter: "Sepia", intensity: intensity, color: nil))
        wheelContent.append(ApplyFilter(filter: "MonoColor", intensity: intensity, color: colors))
        wheelContent.append(ApplyFilter(filter: "Noir", intensity: nil, color: nil))
        wheelContent.append(ApplyFilter(filter: "Inverted", intensity: nil, color: nil))
        wheelContent.append(ApplyFilter(filter: "Vintage", intensity: nil, color: nil))
        
        filterPicker.dataSource = self
        filterPicker.delegate = self
        
        if image != nil {
            popUp.isHidden = true
            imageView.image = UIImage(data: image!.image)
            orgImg = imageView.image
            
        } else {
            editBar.isHidden = true
            popUp.layer.cornerRadius = 10.0
            popUp.isHidden = false
        }
    }
    
    @IBAction func filter() {
        if filterPicker.isHidden {
            filterPicker.isHidden = false
            addFilterButton.isHidden = false
        } else {
            filterPicker.isHidden = true
            addFilterButton.isHidden = true
        }
    }
    
    @IBAction func addFilter() {
        
        switch pickedFilter {
        case "Sepia":
            let img = Filters.main.sepiaTone(value: (Float(pickedIntensity)! / 10), image: orgImg, context: context)
            imageView.image = img
        case "MonoColor":
            let img = Filters.main.greyScale(value: (Float(pickedIntensity)! / 10), color: pickedColor, image: orgImg, context: context)
            imageView.image = img
        case "Inverted":
            let img = Filters.main.invert(image: orgImg, context: context)
            imageView.image = img
        case "Noir":
            let img = Filters.main.noir(image: orgImg, context: context)
            imageView.image = img
        case "Vintage":
            let img = Filters.main.vintage(image: orgImg, context: context)
            imageView.image = img 
        default:
            print("unknown filter")
        }
    }
    
    @IBAction func crop() {
        presentCropViewController()
    }

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
        orgImg = imageView.image
    }
}

extension EditImageController: UIPickerViewDelegate {
    func numberOfComponents(in: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return wheelContent.count
        } else if component == 1 {
            let selectedFilter = filterPicker.selectedRow(inComponent: 0)
            return wheelContent[selectedFilter].intensity?.count ?? 0
        } else {
            let selectedFilter = filterPicker.selectedRow(inComponent: 0)
            return wheelContent[selectedFilter].color?.count ?? 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return wheelContent[row].filter
        } else if component == 1 {
            let selectedFilter = filterPicker.selectedRow(inComponent: 0)
            return wheelContent[selectedFilter].intensity?[row] ?? ""
        } else {
            let selectedFilter = filterPicker.selectedRow(inComponent: 0)
            return wheelContent[selectedFilter].color?[row] ?? ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterPicker.reloadComponent(1)
        filterPicker.reloadComponent(2)
        
        let filter = filterPicker.selectedRow(inComponent: 0)
        
        if filterPicker.selectedRow(inComponent: 1) >= 0 {
            let intensity = filterPicker.selectedRow(inComponent: 1)
            pickedIntensity = wheelContent[filter].intensity?[intensity] ?? ""
        }
        
        if filterPicker.selectedRow(inComponent: 2) >= 0 {
            let color = filterPicker.selectedRow(inComponent: 2)
            pickedColor = wheelContent[filter].color?[color] ?? ""
        }

        pickedFilter = wheelContent[filter].filter
    }
}

extension EditImageController: CropViewControllerDelegate {
    func presentCropViewController() {
        let image: UIImage = imageView.image!
        
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            // 'image' is the newly cropped version of the original image
        
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        
        self.imageView.isHidden = false
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
