//
//  WeatherPicsTableViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class WeatherPicsTableViewController: UITableViewController {

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
                                            print("captionTextField = \(captionTextField.text!)")
                                            print("imageURLTextField = \(imageURLTextField.text!)")
                                            let weatherPic = WeatherPic(caption: captionTextField.text!,
                                                                        imageURL: imageURLTextField.text!)
                                            self.weatherPics.insert(weatherPic, at: 0)
                                            
                                            if self.weatherPics.count == 1{
                                                self.tableView.reloadData()
                                            } else{ // animations
                                                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                          with: UITableViewRowAnimation.top)
                                            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        present(alertController, animated: true, completion: nil)
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
            // Delete the row from the data source
            weatherPics.remove(at: indexPath.row)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
