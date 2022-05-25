//
//  Actuality.swift
//  labagare
//
//  Created by rafalimn on 04/05/2022.
//

import Foundation

struct Actualities :  Codable{
    let actualite : [Actuality]
}

struct Actuality :  Codable{
    let titre : String
    let url_image : String
    let age : String
}
