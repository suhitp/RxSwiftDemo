//
//  JSONDecodable.swift
//  RxSwiftDemo
//
//  Created by Suhit on 18/12/16.
//  Copyright © 2016 Suhit. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: AnyObject]

protocol JSONDecodable {
    init?(json: JSONDictionary)
}

func decode<T: JSONDecodable>(_ dictionaries: [JSONDictionary]) -> [T] {
    return dictionaries.flatMap { T(json: $0) }
}

func decode<T: JSONDecodable>(_ dictionary: JSONDictionary) -> T? {
    return T(json: dictionary)
}

func decode<T:JSONDecodable>(_ data: Data) -> [T]? {
    
    do {
        guard let JSONObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [JSONDictionary] else {
            return nil
        }
        return decode(JSONObject) 
        
    } catch {
        return nil
    }
    
}
