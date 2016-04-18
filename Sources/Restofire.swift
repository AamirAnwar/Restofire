//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 01/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// The default configuration used for `requestable` objects.
/// One needs to override baseURL.
public var defaultConfiguration = Configuration()

/// The default request eventually queue to which all the request eventually
/// operations are added when one calls executeTaskEventually: on requestable
/// objects.
public let defaultRequestEventuallyQueue = NSOperationQueue()