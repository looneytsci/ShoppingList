//
//  ViewController.swift
//  MilestoneProject2
//
//  Created by Дмитрий Головин on 11.04.2021.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .done, target: self, action: #selector(clearShoppingList))
    }
    
    @objc private func addItem(action: UIAlertAction) {
        let ac = UIAlertController(title: "Add new item", message: "to the shopping list", preferredStyle: .alert)
        
        ac.addTextField()
        
        let addButton = UIAlertAction(title: "Add",
                                      style: .default) { [weak self, weak ac] action in
            guard let item = ac?.textFields?.first?.text else { return }
            self?.submitItem(item)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(addButton)
        ac.addAction(cancelButton)
        present(ac, animated: true, completion: nil)
    }
    
    private func submitItem(_ item: String) {
        if isReal(item) && !item.isEmpty {
            shoppingList.insert(item, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            sendErrorMessage()
        }
        
        return
    }
    
    private func sendErrorMessage() {
        let ac = UIAlertController(title: "Not correct item", message: "Please, insert correct item", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: addItem)
        ac.addAction(okButton)
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: Clearing shopping list
    
    @objc private func clearShoppingList() {
        self.shoppingList.removeAll()
        self.tableView.reloadData()
        
    }

    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")!
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let things = shoppingList.joined(separator: "\n")
        let shareThings = UIActivityViewController(activityItems: [things], applicationActivities: nil)
        present(shareThings, animated: true, completion: nil)
    }
    // MARK: Item checker
    
    private func isReal(_ item: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: item.utf16.count)
        let misspellrange = checker.rangeOfMisspelledWord(in: item, range: range, startingAt: 0, wrap: true, language: "en")
        
        return misspellrange.location == NSNotFound
    }
}

