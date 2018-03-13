//
//  ContactListPresenter.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/12/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//

import UIKit
import CoreData

protocol ContactListPresenterProtocol: NSObjectProtocol {
    
    func numberOfSections() -> Int
    
    func numberOfRows(at section: Int) -> Int
    
    func contact(at indexPath: IndexPath) -> Contact
    
    func contactName(at indexPath: IndexPath) -> String
    
}

class ContactListPresenter: NSObject {
    
    weak var viewController: ContactListViewControllerProtocol?
    //var fetchController: NSFetchedResultsController<Contact>?
    
    fileprivate lazy var fetchController: NSFetchedResultsController<Contact> = {
        let moc: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),NSSortDescriptor(key: "lastName", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "firstName", cacheName: nil)
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    public convenience init(viewController: ContactListViewControllerProtocol) {
        self.init()
        self.viewController = viewController
        self.fetchController.delegate = self
        prepareViewController()
    }
    
    private func prepareViewController() {
        
    }

}

extension ContactListPresenter: ContactListPresenterProtocol {
    
    func numberOfSections() -> Int {
        return fetchController.sections?.count ?? 0
    }
    
    func numberOfRows(at section: Int) -> Int {
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func contact(at indexPath: IndexPath) -> Contact {
        return fetchController.object(at: indexPath)
    }
    
    func contactName(at indexPath: IndexPath) -> String {
        var name = ""
        let contact = fetchController.object(at: indexPath)
        if let firstName = contact.firstName {
            name = firstName
        }
        if let lastName = contact.lastName {
            name = lastName + " " + name
        }
       
        return name
    }
    
}

extension ContactListPresenter: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        viewController?.reloadTable()
    }
    
}
