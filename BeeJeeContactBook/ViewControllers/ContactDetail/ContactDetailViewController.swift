//
//  ContactDetailViewController.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/12/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//

import UIKit

protocol ContactDetailViewControllerProtocol: NSObjectProtocol {
    
    func close()
    
    func set(firstName: String?, lastName: String?, phoneNumber: String?, streetAddress1: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?)
    
    func showKeyboard(height: CGFloat, duration: Double)
    
    func hideKeyboard(duration: Double)
    
}

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var streetAddress1Field: UITextField!
    @IBOutlet weak var streetAddress2Field: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var presenter: ContactDetailPresenterProtocol!
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ContactDetailPresenter(viewController: self, contact: contact)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.viewWillDisappear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSaveButtonPressed(_ sender: Any) {
        
        presenter.save(firstName: firstNameField.text,
                       lastName: lastNameField.text,
                       phoneNumber: phoneNumberField.text,
                       streetAddress1: streetAddress1Field.text,
                       streetAddress2: streetAddress2Field.text,
                       city: cityField.text,
                       state: stateField.text,
                       zipCode: zipCodeField.text)
        
    }
    
    @IBAction func onCancelButtonPressed(_ sender: Any) {
        presenter.cancel()
    }
    
    @IBAction func onRemoveButtonPressed(_ sender: Any) {
        presenter.remove()
    }

}

extension ContactDetailViewController: ContactDetailViewControllerProtocol {
    
    func set(firstName: String?, lastName: String?, phoneNumber: String?, streetAddress1: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?) {
        firstNameField.text = firstName
        lastNameField.text = lastName
        phoneNumberField.text = phoneNumber
        streetAddress1Field.text = streetAddress1
        streetAddress2Field.text = streetAddress2
        cityField.text = city
        stateField.text = state
        zipCodeField.text = zipCode
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    func showKeyboard(height: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboard(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

extension ContactDetailViewController: UITextFieldDelegate {
     
}
