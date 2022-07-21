//
//  UsersCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import IdentifiedCollections

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

    var selection: Identified<User.ID, UserDetailState?>?
}

struct User: Equatable, Identifiable {
    var id: UUID = .init()
    var firstName: String
    var lastName: String
    var email: String
    var age: Int
    var job: String
}

enum UsersAction: Equatable {
    case detail(UserDetailAction)
    case setNavigation(selection: UUID?)
    case setFirstName(String)
    case onAppear
    case onDisappear
}

let usersReducer = Reducer<UsersState, UsersAction, UsersEnvironment>.combine(
    userDetailReducer
        .optional()
        .pullback(state: \Identified.value, action: .self, environment: { $0 })
        .optional()
        .pullback(
            state: \.selection,
            action: /UsersAction.detail,
            environment: { _ in UserDetailEnvironment() }
        ),
    Reducer { state, action, env in
        switch action {
        case .detail:
            return .none

        case let .setNavigation(selection: .some(id)):
            let detailState = UserDetailState(user: state.users[id: id]!)
            state.selection = Identified(detailState, id: id)
            return .none

        case .setNavigation(selection: .none):
            if let selection = state.selection, let userDetail = selection.value {
                state.users[id: selection.id] = userDetail.user
            }
            state.selection = nil
            return .none

        case .onAppear:
            return env.randomFirstName().map(UsersAction.setFirstName).eraseToEffect()

        case .onDisappear:
            return .cancel(id: RandomGeneratorTimerId.self)

        case let .setFirstName(firstName):
            guard let firstId = state.users.first?.id else {
                return .none
            }
            state.users[id: firstId]?.firstName = firstName
            return .none
        }
    }
)

extension User {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

struct UsersEnvironment {
    var randomFirstName: RandomGenerator.GenerateFirstName
}
