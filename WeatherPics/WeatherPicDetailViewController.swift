//
//  WeatherPicDetailViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class WeatherPicDetailViewController: UIViewController {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: WeatherPic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(showEditDialog))
    }
    
    @objc func showEditDialog() {
        let alertController = UIAlertController(title: "Edit caption",
                                                message: "",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Caption"
            textField.text = self.photo?.caption
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        let updateAction = UIAlertAction(title: "Update",
                                         style: .default) {
                                            (action) in
                                            let captionTextField = alertController.textFields![0]
                                            self.photo?.caption = captionTextField.text!
                                            self.saveContext()
                                            self.captionLabel.text = self.photo?.caption
        }
        alertController.addAction(cancelAction)
        alertController.addAction(updateAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captionLabel.text = self.photo?.caption
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let imgString = photo?.imageURL {
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
}
