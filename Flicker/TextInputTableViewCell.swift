////
////  TextInputTableViewCell.swift
////  Flicker
////
////  Created by Amr fawzy on 6/17/19.
////  Copyright © 2019 Amr fawzy. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TextInputTableViewCell : UITableViewCell ,UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputCell") as! TextInputTableViewCell
//        
//                cell.configure(text: "", placeholder: "Enter some text!")
//                return cell
//    }
//    
////    @IBOutlet weak var searchTextField: UITextField!
//    public func configure(text: String?, placeholder: String) {
//        searchTextField.text = text
//        searchTextField.placeholder = placeholder
//        
//        searchTextField.accessibilityValue = text
//        searchTextField.accessibilityLabel = placeholder
//    }
//}
