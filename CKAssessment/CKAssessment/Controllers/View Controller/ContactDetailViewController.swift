//
//  ContactDetailViewController.swift
//  CKAssessment
//
//  Created by Zebadiah Watson on 10/18/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    var contact: Contact?
    
    //OUTLETS
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        // Do any additional setup after loading the view.
    }
    
    //ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let nameText = NameTextField.text,
            let phoneText = phoneTextField.text,
            let emailText = emailTextField.text else { return }
        
        if let contactToBeUpdated = contact {
            contactToBeUpdated.name = nameText
            contactToBeUpdated.phone = phoneText
            contactToBeUpdated.email = emailText
            ContactController.shared.updateContact(contact: contactToBeUpdated) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.updateViews()
                    }
                } else {
                    ContactController.shared.createContact(name: nameText, phone: phoneText, email: emailText) { (success) in
                        if success {
                            DispatchQueue.main.async {
                                self.updateViews()
                            }
                        }
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        guard let contact = contact else { return }
        NameTextField.text = contact.name
        phoneTextField.text = contact.phone
        emailTextField.text = contact.email
    }
}
