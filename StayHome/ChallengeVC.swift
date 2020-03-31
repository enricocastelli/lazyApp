//
//  ChallengeVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 29/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class ChallengeVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    
    @IBOutlet weak var challengeButton: UIButton!
    
    var pickerView = UIPickerView()
    var fromDates = ["Now", "Tomorrow"]
    var toDates = ["End of the day", "Tomorrow", "Next week"]
    var textFieldOnFocus: UITextField?
    var selectedFromDate: String = "Now"
    var selectedToDate: String = "End of the day"
    
    let player: Player

    init(_ player: Player) {
        self.player = player
        super.init(nibName: String(describing: ChallengeVC.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFields()
        challengeButton.layer.cornerRadius = 8
        pickerView.delegate = self
        pickerView.dataSource = self
        titleLabel.text = "You are about to invite \(player.name) to a lazy challenge!"
        imageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
    }
    
    private func setFields() {
        fromField.inputView = pickerView
        fromField.inputAccessoryView = getToolBar()
        toField.inputView = pickerView
        toField.inputAccessoryView = getToolBar()
        fromField.text = selectedFromDate
        toField.text = selectedToDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.imageView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
    }
    
    func getToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = UIColor.link
        toolBar.sizeToFit()
        self.view.isUserInteractionEnabled = true
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneTapped))
        toolBar.setItems([flexible, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @IBAction func challengeTapped(_ sender: UIButton) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChallengeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldOnFocus = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChallengeVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return textFieldOnFocus == fromField ? fromDates.count : toDates.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if textFieldOnFocus == fromField {
            selectedFromDate = fromDates[row]
            fromField.text = selectedFromDate
        } else {
            selectedToDate = toDates[row]
            toField.text = selectedToDate
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return textFieldOnFocus == fromField ? fromDates[row] : toDates[row]
    }
}
