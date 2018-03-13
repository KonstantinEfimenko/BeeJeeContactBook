//
//  Contact+CoreDataClass.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/12/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    
    class func newEntity() -> Contact {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: CoreDataStack.shared.persistentContainer.viewContext) as! Contact
        contact.contactID = UUID().uuidString
        return contact
    }

}
