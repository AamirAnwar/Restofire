//
//  ResponseSerializable.swift
//  Restofire
//
//  Created by Rahul Katariya on 29/01/18.
//  Copyright © 2018 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.DataResponseSerializer` that is associated with `Requestable`.
public protocol DataResponseSerializable {
    
    associatedtype Response
    
    /// `Retry.default`
    var responseSerializer: DataResponseSerializer<Response> { get }
    
}

public extension DataResponseSerializable where Response == Data {
    
    /// `Retry.default`
    public var responseSerializer: DataResponseSerializer<Response> {
        return DataRequest.dataResponseSerializer()
    }
    
}

/// Represents a `Alamofire.DownloadResponseSerializer` that is associated with `Downloadable`.
public protocol DownloadResponseSerializable {
    
    associatedtype Response
    
    /// `Retry.default`
    var responseSerializer: DownloadResponseSerializer<Response> { get }
    
}

public extension DownloadResponseSerializable where Response == Data {
    
    /// `Retry.default`
    public var responseSerializer: DownloadResponseSerializer<Response> {
        return DownloadRequest.dataResponseSerializer()
    }
    
}
