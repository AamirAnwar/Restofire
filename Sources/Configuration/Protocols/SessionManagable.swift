//
//  SessionManagable.swift
//  Restofire
//
//  Created by Rahul Katariya on 15/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Foundation

/// Represents a `Alamofire.SessionManager` that is associated with `Requestable`.
public protocol SessionManagable {
    
    /// The `sessionManager`.
    var _sessionManager: SessionManager { get }
    
}

public extension SessionManagable where Self: AConfigurable {
    
    /// `Session.default`
    public var _sessionManager: SessionManager {
        return Session.default.sessionManager
    }
    
}
