//
//  ContactListViewController.swift
//  BeeJeeContactBook
//
//  Created by Konstantin Efimenko on 3/12/18.
//  Copyright © 2018 Konstantin Efimenko. All rights reserved.
//

import UIKit

protocol ContactListViewControllerProtocol: NSObjectProtocol {
    
    func reloadTable()
    
}

class ContactListViewController: UIViewController {
    
    let detailSegueName = "detail"
    @IBOutlet weak var tableView: UITableView!
    var presenter: ContactListPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ContactListPresenter(viewController: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: detailSegueName, sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueName {
            if let vc = segue.destination as? ContactDetailViewController,
                let contact = sender as? Contact {
                vc.contact = contact
            }
        }
    }

}

extension ContactListViewController: ContactListViewControllerProtocol {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    
    private static let cellIdentifier = "ContactListCell"
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: ContactListViewController.cellIdentifier)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:ContactListViewController.cellIdentifier)
        }
        cell!.textLabel!.text = presenter.contactName(at: indexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: detailSegueName, sender: presenter.contact(at: indexPath))
    }
    
}
