//
//  ContactController.swift
//  CKAssessment
//
//  Created by Zebadiah Watson on 10/18/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    
    var contacts: [Contact] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - CRUD
    func createContact(name: String, phone: String, email: String, completion: @escaping (Bool) -> Void) {
        let newContact = Contact(name: name, phone: phone, email: email)
        let newRecord = CKRecord(contact: newContact)
        publicDB.save(newRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record, let savedContact = Contact(ckRecord: record)
                else { completion(false); return }
            
            self.contacts.append(savedContact)
            print("successfully saved new contact")
            completion(true)
        }
    }
    
    func fetchAllContacts(completion: @escaping (Bool) ->Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactConstants.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = foundRecords else { completion(false); return }
            let contacts = records.compactMap( { Contact(ckRecord: $0) } )
            
            self.contacts = contacts
            print("fetched contacts successfully")
            completion(true)
            }
        }
    
    func updateContact(contact: Contact, completion: @escaping (Bool) -> Void) {
        let recordToUpdate = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard recordToUpdate == records?.first else {
                print("unexpected rcord was updated")
                completion(false)
                return
            }
            print("updated \(recordToUpdate.recordID) successfully")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    func deleteContact(contact: Contact, completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [contact.ckRecordID])
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { _, recordIDs, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard contact.ckRecordID == recordIDs?.first else {
                completion(false); return }
            print("successfully deleted contact record")
            completion(true)
        }
        publicDB.add(operation)
    }
}
