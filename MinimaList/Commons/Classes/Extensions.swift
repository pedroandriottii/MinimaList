//
//  Extensions.swift
//  MinimaList
//
//  Created by Pedro Andriotti on 01/07/24.
//

import Foundation

extension Dictionary {
    func buildQueryString() -> String {
        var urlVars:[String] = []
        for (key, value) in self {
            if value is Array<Any> {
                for v in value as! Array<Any> {
                    if let encodedValue = "(v)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                        urlVars.append((key as! String) + "[]=" + encodedValue)
                    }
                }
            }else{
                if let val = value as? String {
                    if let encodedValue = val.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                        urlVars.append((key as! String) + "=" + encodedValue)
                    }
                }else{
                    urlVars.append((key as! String) + "=(value)")
                }
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
}

extension URLResponse {

    func getStatusCode() -> Int {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return 0
    }
}
