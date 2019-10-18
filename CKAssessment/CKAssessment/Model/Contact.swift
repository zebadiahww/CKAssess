//
//  COntact.swift
//  CKAssessment
//
//  Created by Zebadiah Watson on 10/18/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import Foundation
import CloudKit

struct ContactConstants {
    static let recordTypeKey = "Contact"
    static let nameKey = "name"
    static let phoneKey = "phone"
    static let emailKey = "email"
}

class Contact {
    
    var name: String
    var phone: String
    var email: String
    let ckRecordID: CKRecord.ID
    
    init(name: String, phone: String, email: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phone = phone
        self.email = email
        self.ckRecordID = ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactConstants.nameKey] as? String,
            let phone = ckRecord[ContactConstants.phoneKey] as? String,
            let email = ckRecord[ContactConstants.emailKey] as? String else {return nil}
        
        self.init(name: name, phone: phone, email: email, ckRecordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactConstants.recordTypeKey, recordID: contact.ckRecordID)
        setValue(contact.name, forKey: ContactConstants.nameKey)
        setValue(contact.phone, forKey: ContactConstants.phoneKey)
        setValue(contact.email, forKey: ContactConstants.emailKey)
    }
}

extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
