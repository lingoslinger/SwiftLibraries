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
    
    var tempLibraryArray : NSMutableArray = []
    var sectionDictionary : NSMutableDictionary = [:]
    var sectionTitles : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let libraryURLSession = LibraryURLSession();
        let completionHander : SessionCompletionHandler = {(data : Data?, response : URLResponse?, error : Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                let responseArray = data!.jsonArrayValue
                for libraryDict in responseArray {
                    let library = Library.init(fromDictionary: libraryDict as NSDictionary)
                    self.tempLibraryArray.add(library)
                }
                DispatchQueue.main.async(execute: {
                    self.setupSectionsWithLibraryArray()
                    self.tableView.reloadData()
                })
            }
            else {
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

// MARK: UITableViewDataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitles[section]
        let sectionArray = self.sectionDictionary.object(forKey: sectionTitle) as! NSArray
        return sectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell")
        let sectionTitle = self.sectionTitles[indexPath.section]
        let sectionArray = self.sectionDictionary.object(forKey: sectionTitle) as! NSArray
        let library = sectionArray[indexPath.row]
        cell?.textLabel?.text = (library as AnyObject).name
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section] as? String
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitles as? [String]
    }
    
// MARK: navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LibraryDetailViewController" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailViewController = segue.destination as! LibraryDetailViewController
            let sectionTitle = self.sectionTitles[indexPath.section]
            let sectionArray = self.sectionDictionary.object(forKey: sectionTitle) as! NSArray
            detailViewController.detailLibrary = sectionArray[indexPath.row] as! Library
        }
    }
    
// MARK: private methods
    func setupSectionsWithLibraryArray() {
        for element in self.tempLibraryArray {
            if let library : Library = (element as? Library) {
                let firstLetterOfName = (library.name as NSString).substring(to: 1)
                if (self.sectionDictionary.object(forKey: firstLetterOfName) == nil) {
                    let sectionArray : NSMutableArray = [library]
                    self.sectionDictionary.setObject(sectionArray, forKey: firstLetterOfName as NSCopying)
                } else {
                    (self.sectionDictionary[firstLetterOfName] as! NSMutableArray).add(library)
                }
                
            } else {
                // TODO: error handling for unwrapped optional
            }
        }
        let unsortedLetters = self.sectionDictionary.allKeys as! [String]
        self.sectionTitles = unsortedLetters.sorted() as NSArray
    }
}
