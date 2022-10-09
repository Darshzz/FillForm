//
//  ImagePicker.swift
//  FillForm
//
//  Created by Darsh on 07/10/22.
//

import Foundation
import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate {
    
    var callBackImage: ((UIImage) -> Void)?
    
    func openPicker() {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ [weak self] (UIAlertAction) in
                self?.openCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default , handler:{ [weak self] (UIAlertAction)  in
                self?.openPhotoLibrary()
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction) in
                alert.dismiss(animated:true, completion: nil)
            }))
        //uncomment for iPad Support
        //alert.popoverPresentationController?.sourceView = self.view
        
        UIApplication.currentViewController()?.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            UIApplication.currentViewController()?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            UIApplication.currentViewController()?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage

        callBackImage?(UIImage(data: image.jpegData(compressionQuality: 0.25)!)!)
        UIApplication.currentViewController()?.dismiss(animated:true, completion: nil)
    }
}
