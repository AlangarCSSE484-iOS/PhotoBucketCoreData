//
//  PhotoBucketTableViewController.swift
//  PhotoBucket
//
//  Created by CSSE Department on 4/16/18.
//  Copyright © 2018 CSSE Department. All rights reserved.
//

import UIKit

class PhotoBucketTableViewController: UITableViewController {
    
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
                                                print("caption: \(captionTextField.text!)")
                                                print("URL: \(imageURLTextField.text!)")
                                                let photo = Photo(caption: captionTextField.text!,
                                                                  image: imageURLTextField.text!)
                                                self.photoBucket.insert(photo, at: 0)
                                                
                                                if self.photoBucket.count == 1 {
                                                    self.tableView.reloadData()
                                                } else {
                                                    self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                              with: UITableViewRowAnimation.top)
                                                }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createPhotoAction)
        
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            photoBucket.remove(at: indexPath.row)
            if photoBucket.count == 0{
                tableView.reloadData()
                self.setEditing(false, animated: true)
            } else {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            

        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
