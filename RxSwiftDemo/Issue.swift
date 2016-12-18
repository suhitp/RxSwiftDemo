//
//  Issue.swift
//  RxSwiftDemo
//
//  Created by Suhit on 18/12/16.
//  Copyright © 2016 Suhit. All rights reserved.
//

import UIKit

struct Issue {
    
    let identifier: Int
    let number: Int
    let title: String
    let body: String
}

extension Issue: JSONDecodable {
    
    init?(json: JSONDictionary)  {
        
        guard let identifier = json["id"] as? Int,
            let number = json["number"] as? Int,
            let title = json["title"] as? String,
            let body = json["body"] as? String else {
                return nil
        }
        
        self.identifier = identifier
        self.number = number
        self.title = title
        self.body = body
    }
}
