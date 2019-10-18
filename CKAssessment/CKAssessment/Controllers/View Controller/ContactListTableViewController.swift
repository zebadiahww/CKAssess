//
//  ContactListTableViewController.swift
//  CKAssessment
//
//  Created by Zebadiah Watson on 10/18/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    // Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }
    
    // ACTIONS
    @IBAction func addButtonTapped(_ sender: Any) {
        PresentAlert()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.shared.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactToDelete = ContactController.shared.contacts[indexPath.row]
            guard let index = ContactController.shared.contacts.firstIndex(of: contactToDelete)
                else { return }
            ContactController.shared.deleteContact(contact: contactToDelete) { (success) in
                if success {
                    ContactController.shared.contacts.remove(at: index)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }
    
    //MARK: - helper functions
    func fetchContacts() {
        ContactController.shared.fetchAllContacts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func PresentAlert() {
        let alert = UIAlertController(title: "Contact", message: "Create New Contact", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "phone number"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "email address"
        }
        
        let addContactAction = UIAlertAction(title: "add", style: .default) { (_) in
            guard let name = alert.textFields?[0].text,
                let phoneNumber = alert.textFields?[1].text,
                let emailAddress = alert.textFields?[2].text,
                !name.isEmpty
                else { return }
            ContactController.shared.createContact(name: name, phone: phoneNumber, email: emailAddress) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(addContactAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let index = tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? ContactDetailViewController else { return }
                let contactToSend = ContactController.shared.contacts[index.row]
                destinationVC.contact = contactToSend
            }
        }
    }
}
