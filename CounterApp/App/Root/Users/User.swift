//
//  User.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import Foundation

struct User: Equatable, Identifiable {
    var id: UUID = .init()
    var firstName: String
    var lastName: String
    var email: String
    var age: Int
    var job: String
}
