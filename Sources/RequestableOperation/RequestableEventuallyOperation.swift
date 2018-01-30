//
//  RequestableEventuallyOperation.swift
//  Restofire
//
//  Created by Rahul Katariya on 28/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

#if !os(watchOS)
    
import Foundation

/// A `DataRequestOperation`, when added to an `NSOperationQueue` moitors the
/// network reachability and executes the `Requestable` when the network
/// is reachable.
///
/// - Note: Do not call `start()` directly instead add it to an `NSOperationQueue`
/// because calling `start()` will begin the execution of work regardless of network reachability
/// which is equivalant to `DataRequestOperation`.
open class RequestableEventuallyOperation<R: Requestable>: RequestableOperation<R> {
    
    fileprivate let networkReachabilityManager = NetworkReachabilityManager()
    
    override init(requestable: R, completionHandler: ((DataResponse<Data>) -> Void)?) {
        super.init(requestable: requestable, completionHandler: completionHandler)
        self.isReady = false
        networkReachabilityManager?.listener = { status in
            switch status {
            case .reachable(_):
                if self.pause {
                    self.resume = true
                    self.executeRequest()
                } else {
                    self.isReady = true
                }
            default:
                if self.isFinished == false && self.isExecuting == false {
                    self.isReady = false
                } else {
                    self.pause = true
                    self.request.suspend()
                }
            }
        }
        networkReachabilityManager?.startListening()
    }
    
    override func handleErrorDataResponse(_ response: DataResponse<Data>) {
        if let error = response.error as? URLError, error.code == .notConnectedToInternet {
            self.pause = true
        } else {
            super.handleErrorDataResponse(response)
        }
    }
    
}
    
#endif
