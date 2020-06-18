//
//  PGAlamofireManager.swift
//  edetection
//
//  Created by piggybear on 02/05/2017.
//  Copyright © 2017 piggybear. All rights reserved.
//

import Foundation
import Alamofire

final class PGAlamofireManager: Alamofire.SessionManager {
    
    static let sharedManager: PGAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Cookie"] = getCookie
        configuration.httpShouldSetCookies = true
        configuration.httpAdditionalHeaders = headers
        configuration.timeoutIntervalForRequest = 5.0
        return PGAlamofireManager(configuration: configuration)
    }()
    
    static func cancelAllOperations() {
        let sessionManager = PGAlamofireManager.sharedManager
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
}
