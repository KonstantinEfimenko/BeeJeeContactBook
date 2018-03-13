//
//  InitialData.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/13/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//

import UIKit

class InitialData: NSObject {
    
    let initialDataLoadedKey = "initial_data_loaded"
    
    func loadInitialDataIfNeeded() {
        if UserDefaults.standard.bool(forKey: initialDataLoadedKey) {
            return
        }
        if let path = Bundle.main.path(forResource: "InitialData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [Dictionary<String, String>]{
                    for item in jsonResult {
                        let contact = Contact.newEntity()
                        contact.firstName = item["first_name"]
                        contact.lastName = item["last_name"]
                        contact.phoneNumber = item["phone_number"]
                        contact.streetAddress1 = item["street_address_1"]
                        contact.streetAddress2 = item["street_address_2"]
                        contact.city = item["city"]
                        contact.state = item["state"]
                        contact.zipCode = item["zip_code"]
                    }
                    CoreDataStack.shared.saveContext()
                    UserDefaults.standard.set(true, forKey: initialDataLoadedKey)
                }
            } catch {
                print("Some error occured")
            }
        }
    }

}
