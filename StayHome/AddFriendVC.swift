//
//  AddFriendVC.swift
//  StayHome
//
//  Created by Enrico Castelli on 23/03/2020.
//  Copyright © 2020 EC. All rights reserved.
//

import UIKit

class AddFriendVC: UIViewController, FirestoreProvider, AlertProvider {

    @IBOutlet weak var addFriendLabel: UILabel!
    @IBOutlet weak var inviteLinkLabel: UILabel!
    
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var fieldView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var copyLinkButton: UIButton!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var successView: UIImageView!
    @IBOutlet weak var inviteStackView: UIStackView!
    @IBOutlet weak var addStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserver()
        codeField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        codeLabel.text = getID()
        fieldView.layer.cornerRadius = fieldView.frame.height/2
        fieldView.layer.borderColor = UIColor.darkGray.cgColor
        fieldView.layer.borderWidth = 0.5
        self.successView.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBigView()
    }
    
    private func addBigView() {
        guard let color = getAnimal()?.color else { return }
        addButton.backgroundColor = color
        let bigView = RoundView(frame: CGRect(x: 0, y: -view.frame.height/2, width: view.frame.width*2, height: view.frame.width*2))
        bigView.backgroundColor = color
        bigView.center = CGPoint(x: view.center.x, y: 0)
        bigView.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.insertSubview(bigView, at: 0)
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
            bigView.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    func addFriend() {
        guard let text = codeField.text, !text.isEmpty else { return }
        addFriendComplete(text, success: {
            self.view.endEditing(true)
            self.animateSuccess()
        }) { error in
            self.presentGeneralError(error)
        }
    }
    
    private func animateSuccess() {
        let successColor = UIColor(hex: "1FC762")
        UIView.animate(withDuration: 1, animations: {
            self.successView.layer.borderColor = successColor.cgColor
            self.successView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (_) in
            let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func tapped(_ sender: UIButton) {
        addFriend()
    }
    
    @IBAction func copyLinkTapped(_ sender: UIButton) {
    }
    
    @IBAction func copyCodeTapped(_ sender: Any) {
        UIPasteboard.general.string = codeLabel.text
        UIView.animate(withDuration: 0.3, animations: {
            self.codeLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            UIView.animate(withDuration: 0.3) {
                self.codeLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
}

extension AddFriendVC: UITextFieldDelegate {
    
    @objc func textChanged(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addFriend()
        textField.resignFirstResponder()
        return true
    }
    
}

extension AddFriendVC: KeyboardProvider {
  
    func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.inviteStackView.alpha = 0
                self.addStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        UIView.animate(withDuration: 0.3) {
            self.inviteStackView.alpha = 1
            self.addStackView.transform = CGAffineTransform.identity
        }
    }
    
    
}
