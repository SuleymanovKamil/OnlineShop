//
//  AddItemViewController.swift
//  OnlineShop
//
//  Created by Камиль on 09.06.2020.
//  Copyright © 2020 Kamil. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    //MARK: - Vars
    var category: Category!
    var images: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), padding: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismissKeayboard()
        if fieldsAreCompleted() {
            saveToFirebase()
        } else {
            self.hud.textLabel.text = "Заполните все поля"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
//            let alert = UIAlertController(title: "Ошибка", message: "Заполните поля", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        images = []
        showImageGallery()
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        dismissKeayboard()
    }
    
    //MARK: Helper functions
    
    //Проверяем заполнены ли все поля
    private func fieldsAreCompleted() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "")
    }
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    
    //Возвращаемся на предыдущее вью
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Activity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    //MARK: - Save to Firebase
    func saveToFirebase() {
        showLoadingIndicator()
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryId = category.id
        item.description = descriptionTextView.text
        item.price = Double(priceTextField.text!)
        
        if images.count > 0 {
            uploadImages(images: images, itemId: item.id) { (imageLikArray) in
                
                item.imageLinks = imageLikArray
                
                saveItemToFirestore(item)
                
                self.hideLoadingIndicator()
                self.popTheView()
            }
            
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
        
    }
    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
}
extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.images = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
