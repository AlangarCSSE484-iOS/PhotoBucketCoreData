//
//  PhotoBucketTableViewController.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class PhotoBucketTableViewController: UITableViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let PhotoBucketCellIdentifier = "PhotoBucketCell"
    let NoPhotoBucketCellIdentifier = "NoPhotoBucketCell"
    let ShowDetailSegueIdentifier = "ShowDetailSegue"
    
    var photoBucket = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(showAddDialog))
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePhotoBucketArray()
        tableView.reloadData()
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
        
        let createPhotoAction = UIAlertAction(title: "Add Photo",
                                              style: .default) {
                                                (action) in
                                                let captionTextField = alertController.textFields![0]
                                                let imageURLTextField = alertController.textFields![1]

                                                let newPhoto = Photo(context: self.context)
                                                
                                                if imageURLTextField.text! == ""{
                                                    newPhoto.imageURL = self.getRandomImageUrl()
                                                } else {
                                                    newPhoto.imageURL = imageURLTextField.text!
                                                }
                                                newPhoto.caption = captionTextField.text!
                                                newPhoto.timestamp = Date()
                                                self.saveContext()
                                                self.updatePhotoBucketArray()
                                                self.tableView.reloadData()
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
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    //error here, but idk why :(
    func updatePhotoBucketArray() {
        let request: NSFetchRequest<Photo> = Photo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            photoBucket = try context.fetch(request)
        } catch {
            fatalError("Unresolved Core Data error \(error)")
        }
        
    }

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
            context.delete(photoBucket[indexPath.row])
            self.saveContext()
            updatePhotoBucketArray()
            
            if photoBucket.count == 0{
                tableView.reloadData()
                self.setEditing(false, animated: true)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            

        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! PhotoBucketDetailViewController).photoToAdd =
                    photoBucket[indexPath.row]
            }
        }
    }
 

}
