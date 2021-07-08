//
//  LibraryURLSession.swift
//  SwiftLibraries
//
//  Created by Allan Evans on 7/21/16.
//  Copyright © 2016 - 2021 Allan Evans. All rights reserved.
//

import UIKit

class LibraryURLSession: URLSession {
    func sendRequest(_ completionHandler: (@escaping(SessionCompletionHandler))) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "https://data.cityofchicago.org/resource/x8fc-8rcq.json") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request, completionHandler:completionHandler)
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
