//
//  PhotoBucketTableViewController.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit
import Firebase


class PhotoBucketTableViewController: UITableViewController {
    
    var currentUserCollectionRef: CollectionReference!
    var photoRef: CollectionReference!
    var photoListener: ListenerRegistration!
    
    let PhotoBucketCellIdentifier = "PhotoBucketCell"
    let NoPhotoBucketCellIdentifier = "NoPhotoBucketCell"
    let ShowDetailSegueIdentifier = "ShowDetailSegue"
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    
    var photoBucket = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
//                                                                 target: self,
//                                                                 action: #selector(showAddDialog))
     //   self.navigationItem.rightBarButtonItem = 
        
        photoRef = Firestore.firestore().collection("photos")
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //anonymous auth just for now
        if (Auth.auth().currentUser == nil) {
            Auth.auth().signInAnonymously { (user, error) in
                if (error == nil) {
                    print("You are now signed in using Anonymous auth. uid: \(user!.uid)")
                    self.setupFirebaseObservers()
                } else {
                    print("Error with anonymous auth: \(error!.localizedDescription). \(error.debugDescription)")
                }
            }
        } else {
            print("You are already signed in as \(Auth.auth().currentUser!.uid)")
            self.setupFirebaseObservers()
        }
        
        
        self.photoBucket.removeAll()
        photoListener = photoRef.order(by: "timestamp", descending: true).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("error fetching photos. error: \(error!.localizedDescription)")
                return
            }
            snapshot.documentChanges.forEach{(docChange) in
                if (docChange.type == .added) {
                    self.photoAdded(docChange.document)
                } else if (docChange.type == .modified) {
                    self.photoUpdated(docChange.document)
                } else if (docChange.type == .removed) {
                    self.photoRemoved(docChange.document)
                }
            }
            
            self.photoBucket.sort(by: { (p1, p2) -> Bool in
                return p1.timestamp > p2.timestamp
            })
            self.tableView.reloadData()
        })
    }
    
    func setupFirebaseObservers() {
        guard let currentUser = Auth.auth().currentUser else { return }
        currentUserCollectionRef = Firestore.firestore().collection(currentUser.uid)
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Photo Bucket Menu",
                                   message: "What would you like to do?",
                                   preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let addPhotoAction = UIAlertAction(title: "Add Photo",
                                           style: .default) { (action) in
                                            self.showAddDialog()
                                            print("pressed add")
        }
        
        let signOutPhotoAction = UIAlertAction(title: "Sign out",
                                               style: .destructive) { (action) in
                                                self.appDelegate.handleLogout()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        ac.addAction(addPhotoAction)
        ac.addAction(signOutPhotoAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    
    func photoAdded(_ document: DocumentSnapshot){
        let newPhoto = Photo(documentSnapshot: document)
        photoBucket.append(newPhoto)
    }
    
    func photoUpdated(_ document: DocumentSnapshot){
        let modifiedPhoto = Photo(documentSnapshot: document)
        for p in photoBucket {
            if (p.id == modifiedPhoto.id){
                p.imageURL = modifiedPhoto.imageURL
                p.caption = modifiedPhoto.caption
                break
            }
        }
    }
    
    func photoRemoved(_ document: DocumentSnapshot){
        for i in 0..<photoBucket.count {
            if photoBucket[i].id == document.documentID{
                photoBucket.remove(at: i)
                break
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        photoListener.remove()
    }
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Add a new Photo!",
                                                message: "",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Caption"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Image URL"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
//        let createPhotoAction = UIAlertAction(title: "Add Photo",
//                                              style: .default) {
//                                                (action) in
//                                                let captionTextField = alertController.textFields![0]
//                                                let imageURLTextField = alertController.textFields![1]
//
//                                                let newPhoto = Photo(context: self.context)
//
//                                                if imageURLTextField.text! == ""{
//                                                    newPhoto.imageURL = self.getRandomImageUrl()
//                                                } else {
//                                                    newPhoto.imageURL = imageURLTextField.text!
//                                                }
        
        
//                                                newPhoto.caption = captionTextField.text!
//                                                newPhoto.timestamp = Date()
//                                                self.saveContext()
//                                                self.updatePhotoBucketArray()
//                                                self.tableView.reloadData()
//        }
        
        let createPhotoAction = UIAlertAction(title: "Add Photo",
                                              style: .default) {
                                                (action) in
                                                let captionTextField = alertController.textFields![0]
                                                let imageURLTextField = alertController.textFields![1]
                                                
                                                if imageURLTextField.text == "" {
                                                    imageURLTextField.text = self.getRandomImageUrl()
                                                }
                                            
                                                let newPhoto = Photo(imageURL: imageURLTextField.text!,
                                                                     caption: captionTextField.text!)
                                                
                                                self.photoRef.addDocument(data: newPhoto.data)
                                                
                                                
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createPhotoAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomImageUrl() -> String {
        let testImages = ["https://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG",
                          "https://upload.wikimedia.org/wikipedia/commons/6/6b/Mount_Carmel_forest_fire14.jpg"]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }
    
//    func saveContext() {
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//    }
    
    //error here, but idk why :(
//    func updatePhotoBucketArray() {
//        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
//
//        do {
//            photoBucket = try context.fetch(request)
//        } catch {
//            fatalError("Unresolved Core Data error \(error)")
//        }
//
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(photoBucket.count, 1)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if photoBucket.count == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: NoPhotoBucketCellIdentifier, for: indexPath)
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: PhotoBucketCellIdentifier, for: indexPath)
            let photo = photoBucket[indexPath.row]
            cell.textLabel?.text = photo.caption
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You just pressed \(photoBucket[indexPath.row])")
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return photoBucket.count > 0
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if photoBucket.count == 0{
            super.setEditing(false, animated: false)
        }
        else {
            super.setEditing(true, animated: animated)
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            photoBucket.remove(at: indexPath.row)
//            if photoBucket.count == 0{
//                tableView.reloadData()
//                self.setEditing(false, animated: true)
//            } else {
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
            let photoToDelete = photoBucket[indexPath.row]
            photoRef.document(photoToDelete.id!).delete()

        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PhotoBucketDetailViewController).photoRef
                    = photoRef.document(photoBucket[indexPath.row].id!)
            }
        }
    }
 

}
