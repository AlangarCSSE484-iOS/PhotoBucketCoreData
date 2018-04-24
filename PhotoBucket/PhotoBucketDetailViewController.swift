//
//  PhotoBucketDetailViewController.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase

class PhotoBucketDetailViewController: UIViewController {

    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var photoToAdd : Photo?
    
    var photoRef: DocumentReference?
    var photoListener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(showEditDialog))

    }
    
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit Caption",
                                                message: "",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Caption"
            textField.text = self.photoToAdd?.caption
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        let updateAction =  UIAlertAction(title: "Update",
                                               style: .default) {
                                                (action) in
                                                let captionTextField = alertController.textFields![0]
                                                self.photoToAdd?.caption = captionTextField.text!
                                                //self.updateView()
                                              //  self.saveContext()
                                                self.captionLabel.text = self.photoToAdd?.caption
                                               self.photoRef?.setData(self.photoToAdd!.data)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListener = photoRef?.addSnapshotListener({ (documentSnapshot, error) in
            if let error = error {
                print("Error getting the document: \(error.localizedDescription)")
                return
            }
            if !documentSnapshot!.exists {
                print("This document got deleted by someone else!")
                return
            }
            self.photoToAdd = Photo(documentSnapshot: documentSnapshot!)
            self.updateView()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photoListener.remove()
    }
    
    func updateView() {
        self.captionLabel.text = self.photoToAdd?.caption
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let imgString = photoToAdd?.imageURL {
            if let imgUrl = URL(string: imgString) {
                DispatchQueue.global().async { // Download in the background
                    do {
                        let data = try Data(contentsOf: imgUrl)
                        DispatchQueue.main.async { // Then update on main thread
                            self.imageView.image = UIImage(data: data)
                        }
                    } catch {
                        print("Error downloading image: \(error)")
                    }
                }
            }
        }
    }
    
//    func saveContext() {
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}
