//
//  ApiService.swift
//  ApiService
//
//  Created by jorge.garcia on 19/10/18.
//  Copyright © 2018 jorge.garcia. All rights reserved.
//

import Foundation

public class ApiService<T: Codable, R: Codable, F: Codable> {
    
    public init(){}
    public static func excecuteService(request: T, serviceConfig: ServiceConfig, completion: @escaping (R?, AnyObject?, Bool) -> Void) {
        let serviceUrl: String = serviceConfig.url!
        let url = URL(string: serviceUrl)
        var urlRequest = URLRequest(url: (url)!)
        urlRequest.httpMethod = serviceConfig.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let jsonBody = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonBody
        } catch {
            completion(nil,error as AnyObject,true)
        }
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = serviceConfig.timeOut!
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil{
                completion(nil, error as AnyObject, true)
                return
            }
            if data == nil{
                completion(nil, error as AnyObject, true)
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonResponse = try decoder.decode(R.self, from: data!)
                        completion(jsonResponse, nil, false)
                        return
                    } catch {
                        completion(nil, error as AnyObject, true)
                        return
                    }
                } else {
                    do {
                        let jsonFault = try JSONDecoder().decode(F.self, from: data!)
                        completion(nil, jsonFault as AnyObject, true)
                        return
                    } catch {
                        completion(nil, error as AnyObject, true)
                        return
                    }
                }
            } else {
                completion(nil, error as AnyObject, true)
                return
            }
        })
        task.resume()
    }
}
