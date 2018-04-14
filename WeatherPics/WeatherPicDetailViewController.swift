//
//  WeatherPicDetailViewController.swift
//  WeatherPics
//
//  Created by Kiana Caston on 4/13/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class WeatherPicDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBOutlet weak var quoteLabel: UILabel!
//    @IBOutlet weak var movieLabel: UILabel!
//
//    var movieQuote: MovieQuote?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
//                                                            target: self,
//                                                            action: #selector(showEditDialog))
//    }
//
//    @objc func showEditDialog() {
//        let alertController = UIAlertController(title: "Edit movie quote",
//                                                message: "",
//                                                preferredStyle: .alert)
//
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Quote"
//            textField.text = self.movieQuote?.quote
//        }
//        alertController.addTextField { (textField) in
//            textField.placeholder = "Movie Title"
//            textField.text = self.movieQuote?.movie
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .cancel,
//                                         handler: nil)
//
//        let createQuoteAction =  UIAlertAction(title: "Edit",
//                                               style: .default) {
//                                                (action) in
//                                                let quoteTextField = alertController.textFields![0]
//                                                let movieTextField = alertController.textFields![1]
//                                                //  print("quoteTextField = \(quoteTextField.text!)")
//                                                //  print("movieTextField = \(movieTextField.text!)")
//                                                self.movieQuote?.quote = quoteTextField.text!
//                                                self.movieQuote?.movie = movieTextField.text!
//                                                self.updateView()
//
//        }
//
//        alertController.addAction(cancelAction)
//        alertController.addAction(createQuoteAction)
//        present(alertController, animated: true, completion: nil)
//    }
//
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        updateView()
//    }
//
//    func updateView() {
//        quoteLabel.text = movieQuote?.quote
//        movieLabel.text = movieQuote?.movie
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.captionLabel.text = self.photo?.caption
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if let imgString = photo?.imageUrl {
//            if let imgUrl = URL(string: imgString) {
//                DispatchQueue.global().async { // Download in the background
//                    do {
//                        let data = try Data(contentsOf: imgUrl)
//                        DispatchQueue.main.async { // Then update on main thread
//                            self.imageView.image = UIImage(data: data)
//                        }
//                    } catch {
//                        print("Error downloading image: \(error)")
//                    }
//                }
//            }
//        }
//    }
    
    func getRandomImageUrl() -> String {
        let testImages = ["https://upload.wikimedia.org/wikipedia/commons/0/04/Hurricane_Isabel_from_ISS.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/0/00/Flood102405.JPG",
                          "https://upload.wikimedia.org/wikipedia/commons/6/6b/Mount_Carmel_forest_fire14.jpg"]
        let randomIndex = Int(arc4random_uniform(UInt32(testImages.count)))
        return testImages[randomIndex];
    }



}
