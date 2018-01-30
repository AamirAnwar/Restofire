//
//  DownloadableOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// An NSOperation that executes the `Downloadable` asynchronously on `start()`
/// or when added to a NSOperationQueue
///
/// - Note: Auto Retry is available only in `DataRequestEventuallyOperation`.
open class DownloadableOperation<R: Downloadable>: BaseOperation {
    
    let downloadable: R
    var request: DownloadRequest!
    var retryAttempts = 0
    let completionHandler: ((DownloadResponse<Data>) -> Void)?
    
    init(downloadable: R, completionHandler: ((DownloadResponse<Data>) -> Void)?) {
        self.downloadable = downloadable
        self.retryAttempts = downloadable.maxRetryAttempts
        self.completionHandler = completionHandler
        super.init()
    }
    
    /// Begins the execution of the operation.
    open override func start() {
        super.start()
        executeRequest()
    }
    
    @objc func executeRequest() {
        request = downloadable.request()
        downloadable.didStart(request: request)
        request.responseData(
            queue: downloadable.queue
        ) { (response: DownloadResponse<Data>) in
            
            if response.error == nil {
                self.successful = true
                self.downloadable.didComplete(request: self.request, with: response)
                if let completionHandler = self.completionHandler { completionHandler(response) }
            } else {
                self.handleErrorDataResponse(response)
            }
            let debug = ProcessInfo.processInfo.environment["-me.rahulkatariya.Restofire.Debug"]
            if debug == "1" {
                print(self.request.debugDescription)
            } else if debug == "2" {
                print(self.request.debugDescription)
                print(response)
            } else if debug == "3" {
                print(self.request.debugDescription)
                print(self.request)
                print(response)
            }
        }
    }
    
    func handleErrorDataResponse(_ response: DownloadResponse<Data>) {
        if let error = response.error as? URLError, retryAttempts > 0,
            downloadable.retryErrorCodes.contains(error.code) {
            
            retryAttempts -= 1
            perform(#selector(DownloadableOperation<R>.executeRequest), with: nil, afterDelay: downloadable.retryInterval)
            
        } else {
            failed = true
            downloadable.didComplete(request: request, with: response)
            completionHandler?(response)
        }
    }
    
    /// Advises the operation object that it should stop executing its request.
    open override func cancel() {
        super.cancel()
        request.cancel()
    }
    
}
