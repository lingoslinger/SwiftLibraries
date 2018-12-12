//
//  LibraryTableViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import UIKit
import Foundation

typealias SessionCompletionHandler = (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void

class LibraryTableViewController: UITableViewController {
    
    var libraryArray = [Library]()
    var sectionDictionary = Dictionary<String, [Library]>()
    var sectionTitles = Array<String>.init()
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let libraryURLSession = LibraryURLSession();
        let completionHander : SessionCompletionHandler = {(data : Data?, response : URLResponse?, error : Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                let decoder = JSONDecoder()
                guard let libraryArray = try? decoder.decode([Library].self, from: data!) else {
                    fatalError("Unable to decode JSON library data")
                }
                self.libraryArray = libraryArray
                DispatchQueue.main.async(execute: {
                    self.setupSectionsWithLibraryArray()
                    self.tableView.reloadData()
                })
            } else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }
        libraryURLSession.sendRequest(completionHander)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitles[section]
        let sectionArray = self.sectionDictionary[sectionTitle]
        return sectionArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell")
        let sectionTitle = self.sectionTitles[indexPath.section]
        let sectionArray = self.sectionDictionary[sectionTitle]
        let library = sectionArray?[indexPath.row]
        cell?.textLabel?.text = library?.name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles
    }
    
    // MARK: - navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryDetailViewController" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailViewController = segue.destination as! LibraryDetailViewController
            let sectionTitle = self.sectionTitles[indexPath.section]
            let sectionArray = self.sectionDictionary[sectionTitle]
            detailViewController.detailLibrary = sectionArray?[indexPath.row]
        }
    }
    
    // MARK: - private methods
    func setupSectionsWithLibraryArray() {
        for library in libraryArray {
            let firstLetterOfName = String.init(library.name?.first ?? Character.init(""))
            if (sectionDictionary[firstLetterOfName] == nil) {
                let sectionArray = [Library]()
                sectionDictionary[firstLetterOfName] = sectionArray
            }
            sectionDictionary[firstLetterOfName]?.append(library)
        }
        let unsortedLetters = self.sectionDictionary.keys
        sectionTitles = unsortedLetters.sorted()
    }
}
