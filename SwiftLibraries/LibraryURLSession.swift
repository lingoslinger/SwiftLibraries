//
//  LibraryURLSession.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import UIKit

class LibraryURLSession: NSURLSession {

    func sendRequest(completionHandler : SessionCompletionHandler) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = NSURL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
        session.finishTasksAndInvalidate();
    }

}
