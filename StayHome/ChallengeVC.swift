//
//  ChallengeVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 29/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class ChallengeVC: UIViewController, FirestoreProvider {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toField: UITextField!
    
    @IBOutlet weak var challengeButton: UIButton!
    
    var imageView: Animator!
    var pickerView = UIPickerView()
    var toDates: [ChallengeDuration] = [ChallengeDuration.EndOfDay, .Tomorrow, .NextWeek]
    var selectedToDate: ChallengeDuration = .EndOfDay
    
    let player: Player

    init(_ player: Player) {
        self.player = player
        super.init(nibName: String(describing: ChallengeVC.self), bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView = Animator(containerView.frame, imageName: "shark", count: 10, frameTime: 0.1)
        containerView.addContentView(imageView)
        imageView.start()
        setField()
        challengeButton.layer.cornerRadius = 8
        pickerView.delegate = self
        pickerView.dataSource = self
        titleLabel.text = "You are about to invite \n\(player.name)\n to a lazy challenge!"
        imageView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
    }
    
    deinit {
        imageView.stop()
    }
    
    private func setField() {
        toField.tintColor = .clear
        toField.inputView = pickerView
        toField.inputAccessoryView = getToolBar()
        toField.text = selectedToDate.rawValue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 1.5) {
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
        createChallenge(player.id, endingDate: selectedToDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChallengeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChallengeVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toDates.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedToDate = toDates[row]
        toField.text = selectedToDate.rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toDates[row].rawValue
    }
}
