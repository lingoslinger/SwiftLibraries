//
//  LibraryURLSession.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 lingo-slingers.org. All rights reserved.
//

import UIKit

class LibraryURLSession: URLSession {
    func sendRequest(_ completionHandler: (@escaping(SessionCompletionHandler))) {
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         My API (GET https://data.cityofchicago.org/resource/x8fc-8rcq.json)
         */
        
        let var URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler:completionHandler)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
