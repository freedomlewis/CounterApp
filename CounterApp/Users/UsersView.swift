//
//  UsersView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/20.
//

import ComposableArchitecture
import IdentifiedCollections
import SwiftUI

struct UsersState: Equatable {
    var users: IdentifiedArrayOf<User> = [
        User(
            firstName: "James",
            lastName: "Smith",
            email: "john@gmail.com",
            age: 14,
            job: "Student"
        ),
        User(
            firstName: "Michael",
            lastName: "Smith",
            email: "michael@gmail.com",
            age: 30,
            job: "Engineer"
        ),
        User(
            firstName: "Mary",
            lastName: "Smith",
            email: "mary@gmail.com",
            age: 29,
            job: "Teacher"
        ),
        User(
            firstName: "David",
            lastName: "Smith",
            email: "david@gmail.com",
            age: 60,
            job: "Farmer"
        )
    ]
}

struct User: Equatable, Identifiable {
    var id: UUID = .init()
    var firstName: String
    var lastName: String
    var email: String
    var age: Int
    var job: String
}

extension User {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

struct UsersAction {}

struct UsersEnvironment {}

let usersReducer = Reducer<UsersState, UsersAction, UsersEnvironment> { _, action, _ in
    switch action {
    default:
        return .none
    }
}

struct UsersView: View {
    let store: Store<UsersState, UsersAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewStore.users) { user in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(user.fullName)").font(.title2)
                        Text("\(user.job)").foregroundColor(.gray)
                    }.padding(.leading)
                    Divider()
                }
            }
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView(
            store: Store(
                initialState: UsersState(),
                reducer: usersReducer,
                environment: UsersEnvironment()
            )
        )
    }
}
