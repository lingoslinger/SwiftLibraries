//
//  LibraryTableViewController.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import UIKit
import Foundation

typealias SessionCompletionHandler = (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void

class LibraryTableViewController: UITableViewController {
    
    var tempLibraryArray : NSMutableArray = []
    var sectionDictionary : NSMutableDictionary = [:]
    var sectionTitles : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let libraryURLSession = LibraryURLSession();
        let completionHander : SessionCompletionHandler = {(data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                let responseArray : NSArray = data!.jsonArrayValue
                for libraryDict in responseArray {
                    let library = Library.init(fromDictionary: libraryDict as! NSDictionary)
                    self.tempLibraryArray.addObject(library)
                }
                dispatch_async(dispatch_get_main_queue(), {
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitles[section]
        let sectionArray = self.sectionDictionary.objectForKey(sectionTitle) as! NSArray
        return sectionArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LibraryTableViewCell")
        let sectionTitle = self.sectionTitles[indexPath.section]
        let sectionArray = self.sectionDictionary.objectForKey(sectionTitle) as! NSArray
        let library = sectionArray[indexPath.row]
        cell?.textLabel?.text = library.name
        return cell!
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section] as? String
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.sectionTitles as? [String]
    }
    
// MARK: navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LibraryDetailViewController" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let detailViewController = segue.destinationViewController as! LibraryDetailViewController
            let sectionTitle = self.sectionTitles[indexPath.section]
            let sectionArray = self.sectionDictionary.objectForKey(sectionTitle) as! NSArray
            detailViewController.detailLibrary = sectionArray[indexPath.row] as! Library
        }
    }
    
// MARK: private methods
    func setupSectionsWithLibraryArray() {
        for element in self.tempLibraryArray {
            if let library : Library = (element as? Library) {
                let firstLetterOfName = (library.name as NSString).substringToIndex(1)
                if (self.sectionDictionary.objectForKey(firstLetterOfName) == nil) {
                    let sectionArray : NSMutableArray = [library]
                    self.sectionDictionary.setObject(sectionArray, forKey: firstLetterOfName)
                } else {
                    self.sectionDictionary[firstLetterOfName]?.addObject(library)
                }
                
            } else {
                // TODO: error handling for unwrapped optional
            }
        }
        let unsortedLetters = self.sectionDictionary.allKeys as! [String]
        self.sectionTitles = unsortedLetters.sort({ (a : String, b: String) -> Bool in
            return a < b
        })
    }
}