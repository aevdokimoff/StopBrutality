//
//  AddCaseVC.swift
//  StopPoliceBrutality
//
//  Created by Artem Evdokimov on 09.06.20.
//  Copyright © 2020 Artem Evdokimov. All rights reserved.
//

import UIKit

class AddCaseVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addImageOrVideoButton: UIButton!
    
    private var placeholderLabel : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtons()
        self.setupTextView()
        self.setupTextViewPlaceholder()
        self.addCancelButtonOnKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func setupButtons() {
        self.addImageOrVideoButton.layer.cornerRadius = 0.5 * self.addImageOrVideoButton.bounds.size.width
        self.addImageOrVideoButton.clipsToBounds = true
        self.addImageOrVideoButton.layer.borderWidth = 1
        self.addImageOrVideoButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupTextView() {
        self.textView.becomeFirstResponder()
        self.textView.keyboardAppearance = .dark
    }
    
    func setupTextViewPlaceholder() {
        self.placeholderLabel = UILabel()
        self.placeholderLabel.text = "Tell us more about your accident..."
        self.placeholderLabel.font = UIFont.systemFont(ofSize: (self.textView.font?.pointSize)!)
        self.placeholderLabel.sizeToFit()
        self.textView.addSubview(self.placeholderLabel)
        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.textView.font?.pointSize)! / 2)
        self.placeholderLabel.textColor = UIColor.lightGray
        self.placeholderLabel.isHidden = !self.textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func addCancelButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = UIColor.red
        var items = [UIBarButtonItem]()
        items.append(done)
        items.append(flexSpace)

        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.textView.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction() {
        self.textView.resignFirstResponder()
    }
    
}
