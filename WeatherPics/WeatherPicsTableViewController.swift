//
//  WeatherPicsTableViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Firebase

class WeatherPicsTableViewController: UITableViewController, UIActionSheetDelegate {
    
    var docRef: DocumentReference!
    var picsRef: CollectionReference!
    var picsListener: ListenerRegistration!
    
    let weatherPicCellIdentifier = "WeatherPicCell"
    let noWeatherPicsCellIdentifier = "NoWeatherPicsCell"
    let showDetailSegueIdentifier = "ShowDetailSegue"
    var weatherPics = [WeatherPic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        navigationItem.leftBarButtonItem = self.editButtonItem
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        //                                                            target: self,
        //                                                            action: #selector(showAddDialog))
        picsRef = Firestore.firestore().collection("pics")
        docRef = Firestore.firestore().collection("pics").document("title")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTitle()
        self.weatherPics.removeAll()
        picsListener = picsRef.order(by: "created", descending: true).limit(to: 50).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching quotes. error: \(error!.localizedDescription)")
                return
            }
            snapshot.documentChanges.forEach{(docChange) in
                if (docChange.type == .added){
                    print("New pic: \(docChange.document.data())")
                    self.picAdded(docChange.document)
                } else if (docChange.type == .modified){
                    print("Modified pic: \(docChange.document.data())")
                    self.picUpdated(docChange.document)
                } else if (docChange.type == .removed){
                    print("Removed pic: \(docChange.document.data())")
                    self.picRemoved(docChange.document)
                }
            }
            self.weatherPics.sort(by: { (pic1, pic2) -> Bool in
                return pic1.created > pic2.created
            })
            self.tableView.reloadData()
        })
        
    }
    
    func setTitle() {
        docRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document. \(error.localizedDescription)")
                return
            }
            self.navigationItem.title = documentSnapshot?.get("title") as? String
        }
    }
    
    //    @IBAction func menuButtonPressed(_ sender: Any) {
    //        print("Menu button pressed")
    //        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Save", "Delete")
    //
    //        actionSheet.showInView(self.view)
    
    //        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .ActionSheet)
    //
    //        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
    //            print("Cancel")
    //        }
    //        actionSheetControllerIOS8.addAction(cancelActionButton)
    //
    //        let saveActionButton = UIAlertAction(title: "Save", style: .default)
    //        { _ in
    //            print("Save")
    //        }
    //        actionSheetControllerIOS8.addAction(saveActionButton)
    //
    //        let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
    //        { _ in
    //            print("Delete")
    //        }
    //        actionSheetControllerIOS8.addAction(deleteActionButton)
    //        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    
    //    }
    
    func picAdded(_ document: DocumentSnapshot) {
        let newWeatherPic = WeatherPic(documentSnapshot: document)
        weatherPics.append(newWeatherPic)
    }
    
    func picUpdated(_ document: DocumentSnapshot) {
        let modifiedWeatherPic = WeatherPic(documentSnapshot: document)
        
        for weatherPic in weatherPics {
            if (weatherPic.id == modifiedWeatherPic.id) {
                weatherPic.caption = modifiedWeatherPic.caption
                weatherPic.imageURL = modifiedWeatherPic.imageURL
                break
            }
        }
    }
    
    func picRemoved(_ document: DocumentSnapshot) {
        for i in 0..<weatherPics.count {
            if weatherPics[i].id == document.documentID {
                weatherPics.remove(at: i)
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        picsListener.remove()
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Photo Bucket Options",
                                                message: "",
                                                preferredStyle: .actionSheet)
        
        let addPhotoActionButton = UIAlertAction(title: "Add Photo",
                                                 style: .default) { (action) in
                                                    self.showAddDialog()
                                                    print("add")
        }
        
        let signoutActionButton = UIAlertAction(title: "Sign out",
                                                style: .destructive) { (action) in
                                                    self.appDelegate.handleLogout()
        }
        
        let cancelActionButton = UIAlertAction(title: "Cancel",
                                               style: .cancel,
                                               handler: nil)
        
        alertController.addAction(addPhotoActionButton)
        alertController.addAction(signoutActionButton)
        alertController.addAction(cancelActionButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func showAddDialog() {
        let alertController = UIAlertController(title: "Create a new weather pic:",
                                                message: "",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Caption"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Image URL (or blank)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        let createAction = UIAlertAction(title: "Create",
                                         style: .default) {
                                            (action) in
                                            let captionTextField = alertController.textFields![0]
                                            let imageURLTextField = alertController.textFields![1]
                                            
                                            let newWeatherPic = WeatherPic(caption: captionTextField.text!,
                                                                           imageURL: imageURLTextField.text!)
                                            
                                            if imageURLTextField.text! == "" {
                                                newWeatherPic.imageURL = self.getRandomImageUrl()
                                            } else {
                                                newWeatherPic.imageURL = imageURLTextField.text!
                                            }
                                            
                                            self.picsRef.addDocument(data: newWeatherPic.data)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getRandomImageUrl() -> String {
        let testImages = ["https://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG",
                          "https://upload.wikimedia.org/wikipedia/commons/6/6b/Mount_Carmel_forest_fire14.jpg"]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if weatherPics.count == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(weatherPics.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if weatherPics.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: noWeatherPicsCellIdentifier, for: indexPath)
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: weatherPicCellIdentifier, for: indexPath)
            let weatherPic = weatherPics[indexPath.row]
            cell.textLabel?.text = weatherPic.caption
        }
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return weatherPics.count > 0
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let weatherPicToDelete = weatherPics[indexPath.row]
            picsRef.document(weatherPicToDelete.id!).delete()
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == showDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! WeatherPicDetailViewController).photoRef = picsRef.document(weatherPics[indexPath.row].id!)
            }
        }
    }
}
