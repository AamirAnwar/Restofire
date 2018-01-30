//
//  Restofire.swift
//  Restofire
//
//  Created by Rahul Katariya on 19/04/16.
//  Copyright © 2016 AarKay. All rights reserved.
//

import Alamofire

/// A set of HTTP response status code that do not contain response data.
private let emptyDataStatusCodes: Set<Int> = [204, 205]

class RestofireRequest {
    
    static func dataRequest<R: Requestable>(fromRequestable requestable: R) -> Alamofire.DataRequest {
        let request = requestable.sessionManager.request(requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func downloadRequest<R: Downloadable>(fromRequestable requestable: R) -> Alamofire.DownloadRequest {
        let request = requestable.sessionManager.download(requestable.asUrlRequest()!, to: requestable.destination)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireDownloadValidation.validateDownloadRequest(request: request, requestable: requestable)
        return request
    }
    
    static func fileUploadRequest<R: FileUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.url, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func dataUploadRequest<R: DataUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.data, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func streamUploadRequest<R: StreamUploadable>(fromRequestable requestable: R) -> Alamofire.UploadRequest {
        let request = requestable.sessionManager.upload(requestable.stream, with: requestable.asUrlRequest()!)
        authenticateRequest(request, usingCredential: requestable.credential)
        RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
        return request
    }
    
    static func multipartUploadRequest<R: MultipartUploadable>(fromRequestable requestable: R, encodingCompletion: ((MultipartFormDataEncodingResult) -> Void)? = nil) {
        let localEncodingCompletion = encodingCompletion
        requestable.sessionManager.upload(
            multipartFormData: requestable.multipartFormData,
            usingThreshold: requestable.threshold,
            with: requestable.asUrlRequest()!) { encodingCompletion in
                switch encodingCompletion {
                case .success(let request, let streamingFromDisk, let streamFileURL):
                    authenticateRequest(request, usingCredential: requestable.credential)
                    RestofireRequestValidation.validateDataRequest(request: request, requestable: requestable)
                    let result = MultipartFormDataEncodingResult.success(request: request, streamingFromDisk: streamingFromDisk, streamFileURL: streamFileURL)
                    requestable.encodingCompletion?(result)
                    localEncodingCompletion?(result)
                case .failure(_):
                    requestable.encodingCompletion?(encodingCompletion)
                    localEncodingCompletion?(encodingCompletion)
                }
        }
    }
    
    fileprivate static func authenticateRequest(_ request: Request, usingCredential credential: URLCredential?) {
        guard let credential = credential else { return }
        request.authenticate(usingCredential: credential)
    }

}
