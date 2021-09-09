//
//  LibraryTableViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved. Seriously.
//

import UIKit
import Foundation

typealias SessionCompletionHandler = (_ data : Data?, _ response : URLResponse?, _ error : Error?) -> Void

class LibraryTableViewController: UITableViewController {
    
    @IBOutlet weak var tableViewToggleBarButtonItem: UIBarButtonItem!
    
    var libraryArray = [Library]()
    var sectionDictionary = Dictionary<String, [Library]>()
    var sectionTitles = [String]()
    var tableViewAlphaSort  = true
    
    enum SortBy {
        case location
        case alpha
    }
    
    // MARK: IBActions
    
    @IBAction func tableViewToggleTapped(_ sender: UIBarButtonItem) {
        if tableViewAlphaSort {
            // sort by distance to library
            tableViewToggleBarButtonItem.title = "Alpha"
            tableViewAlphaSort = false
        } else {
            // sort alphabetically
            tableViewToggleBarButtonItem.title = "Location"
            tableViewAlphaSort = true
        }
    }
    
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        newDataRequest()
    }
    
    private func newDataRequest() {
        guard let URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        URLSession.shared.dataTask(with: URL) { data, response, error in
            if (error == nil) {
                let decoder = JSONDecoder()
                guard let libraryArray = try? decoder.decode([Library].self, from: data!) else {
                    fatalError("Unable to decode JSON library data")
                }
                self.libraryArray = libraryArray
                DispatchQueue.main.async {
                    self.setupSectionsWithLibraryArray()
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorDialogWithMessage(message: error?.localizedDescription ?? "Unknown network error")
                }
            }
        }.resume()
    }

    // MARK: - UITableViewDataSource and UITableViewDelegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        let sectionArray = sectionDictionary[sectionTitle]
        return sectionArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell")
        let sectionTitle = sectionTitles[indexPath.section]
        let sectionArray = sectionDictionary[sectionTitle]
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
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let detailViewController = segue.destination as! LibraryDetailViewController
            let sectionTitle = sectionTitles[indexPath.section]
            let sectionArray = sectionDictionary[sectionTitle]
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
        let unsortedLetters = sectionDictionary.keys
        sectionTitles = unsortedLetters.sorted()
    }
}
