//
//  ContactDetailPresenter.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/12/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//

import UIKit

protocol ContactDetailPresenterProtocol: NSObjectProtocol {
    
    func save(firstName: String?, lastName: String?, phoneNumber: String?, streetAddress1: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?)
    
    func cancel()
    
    func remove()
    
    func viewWillAppear()
    
    func viewWillDisappear()
    
}

class ContactDetailPresenter: NSObject {
    
    weak var viewController: ContactDetailViewControllerProtocol?
    weak var contact: Contact?
    
    public convenience init(viewController: ContactDetailViewControllerProtocol, contact: Contact?) {
        self.init()
        self.viewController = viewController
        self.contact = contact
        configureViewController()
    }
    
    func configureViewController() {
        if let contact = contact {
            viewController?.set(firstName: contact.firstName, lastName: contact.lastName, phoneNumber: contact.phoneNumber, streetAddress1: contact.streetAddress1, streetAddress2: contact.streetAddress2, city: contact.city, state: contact.state, zipCode: contact.zipCode)
        }
    }
    
    func closeViewController() {
        viewController?.close()
    }
    
    func viewWillAppear() {
        subscribeForKeyboardNotifications()
    }
    
    func viewWillDisappear() {
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue.size.height
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!.doubleValue
        viewController?.showKeyboard(height: keyboardHeight, duration: duration)
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        var info = notification.userInfo!
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)!.doubleValue
        viewController?.hideKeyboard(duration: duration)
    }

}

extension ContactDetailPresenter: ContactDetailPresenterProtocol {
    
    func save(firstName: String?, lastName: String?, phoneNumber: String?, streetAddress1: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?) {
        if contact == nil {
            contact = Contact.newEntity()
        }
        guard let contact = contact else {
            return
        }
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
        contact.streetAddress1 = streetAddress1
        contact.streetAddress2 = streetAddress2
        contact.city = city
        contact.state = state
        contact.zipCode = zipCode
        CoreDataStack.shared.saveContext()
        closeViewController()
    }
    
    func cancel() {
        closeViewController()
    }
    
    func remove() {
        if let contact = contact {
            CoreDataStack.shared.persistentContainer.viewContext.delete(contact)
            CoreDataStack.shared.saveContext()
        }
        closeViewController()
    }
}
