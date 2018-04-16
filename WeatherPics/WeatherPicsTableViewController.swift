//
//  WeatherPicsTableViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import CoreData

class WeatherPicsTableViewController: UITableViewController {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let weatherPicCellIdentifier = "WeatherPicCell"
    let noWeatherPicsCellIdentifier = "NoWeatherPicsCell"
    let showDetailSegueIdentifier = "ShowDetailSegue"
    var weatherPics = [WeatherPic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showAddDialog))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeatherPicArray()
        tableView.reloadData()
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
                                            
                                            let newWeatherPic = WeatherPic(context: self.context)
    
                                            if imageURLTextField.text! == "" {
                                                newWeatherPic.imageURL = self.getRandomImageUrl()
                                            } else {
                                                newWeatherPic.imageURL = imageURLTextField.text!
                                            }
                                            
                                            newWeatherPic.caption = captionTextField.text!
                                            newWeatherPic.created =  Date()
                                            self.saveContext()
                                            self.updateWeatherPicArray()
                                            self.tableView.reloadData()
                           
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
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func updateWeatherPicArray() {
        // Make a fetch request
        // Execute the request in a try/catch block
        let request: NSFetchRequest<WeatherPic> = WeatherPic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        
        do {
            weatherPics = try context.fetch(request)
        } catch {
            fatalError("Unresolved Core Data error \(error)")
        }
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if weatherPics.count == 0 {
            super.setEditing(false, animated: animated)
        } else {
            super.setEditing(editing, animated: animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            context.delete(weatherPics[indexPath.row])
            self.saveContext()
            updateWeatherPicArray()
            
            // Delete the row from the data source
            if weatherPics.count == 0 {
                tableView.reloadData()
                self.setEditing(false, animated: true)
            }
         else {
            tableView.deleteRows(at: [indexPath],
                                 with: .fade)
            }
        }    
    }
  
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == showDetailSegueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                (segue.destination as! WeatherPicDetailViewController).photo = weatherPics[indexPath.row]
            }
        }
    }
    

}
