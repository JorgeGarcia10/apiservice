//
//  ServiceConfig.swift
//  ApiService
//
//  Created by jorge.garcia on 19/10/18.
//  Copyright © 2018 jorge.garcia. All rights reserved.
//sdsd

import Foundation

public class ServiceConfig {
    
    
    var url: String?
    
    var timeOut: Double?
    
    var nameService: String?
    
    var method: String?
    
    public init(url: String, timeOut: Double, nameService: String, method: String) {
        self.url = url
        self.timeOut = timeOut
        self.nameService = nameService
        self.method = method
    }
}
