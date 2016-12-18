//
//  Repository.swift
//  RxSwiftDemo
//
//  Created by Suhit on 18/12/16.
//  Copyright © 2016 Suhit. All rights reserved.
//

import UIKit

struct Repository {
    
    let identifier: Int
    let language: String
    let name: String
    let fullName: String
}

extension Repository: JSONDecodable {
    
    init?(json: JSONDictionary)  {
        guard let identifier = json["id"] as? Int,
        let language = json["language"] as? String,
        let name = json["name"] as? String,
            let fullName = json["full_name"] as? String else {
                return nil
        }
        
        self.identifier = identifier
        self.name = name
        self.fullName = fullName
        self.language = language
    }
}

