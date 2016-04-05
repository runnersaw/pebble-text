//
//  Downloader.swift
//  PebbleSMS
//
//  Created by Sawyer Vaughan on 2/13/16.
//  Copyright © 2016 Sawyer Vaughan. All rights reserved.
//

import Foundation

class Downloader {
    class func loadFileAsync(url: NSURL, completion:(path:String, error:NSError!) -> Void) {
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let destinationUrl = documentsUrl.URLByAppendingPathComponent(url.lastPathComponent!)
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 200 {
                        if data!.writeToURL(destinationUrl, atomically: true) {
                            completion(path: destinationUrl.path!, error:error)
                        } else {
                            let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                            completion(path: destinationUrl.path!, error:error)
                        }
                    }
                }
            } else {
                completion(path: destinationUrl.path!, error:error)
            }
        })
        task.resume()
    }
}