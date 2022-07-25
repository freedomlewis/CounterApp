//
//  UsersCore.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import IdentifiedCollections

struct UsersState: Equatable {
    var users: IdentifiedArrayOf<User>
    var selection: Identified<User.ID, UserDetailState?>?
    
    init(userNum: Int) {
        self.users = .init(
            uniqueElements: (0..<userNum).map{ _ in
                User(
                    firstName: Randoms.randomFakeFirstName(),
                    lastName: Randoms.randomFakeLastName(),
                    email: "\(String.random(ofLength: 6))@gmail.com",
                    age: Int.random(10, 100),
                    job: Randoms.randomFakeTitle()
                )
            }
        )
    }
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
            state: \UsersState.selection,
            action: /UsersAction.detail,
            environment: \.userDetail
        ),
    Reducer { state, action, env in
        switch action {
        case let .setNavigation(selection: .some(id)):
            let detailState = UserDetailState(
                userInfo: UserInfoState(user: state.users[id: id]!)
            )
            state.selection = Identified(detailState, id: id)
            return .none

        case .setNavigation(selection: .none):
            state.selection = nil
            return .none

        case .onAppear:
            return env.randomFirstName().map(UsersAction.setFirstName).eraseToEffect()

        case .onDisappear:
            return env.cancelGenerator().fireAndForget()

        case let .setFirstName(firstName):
            guard let firstId = state.users.first?.id else {
                return .none
            }
            state.users[id: firstId]?.firstName = firstName
            return .none
            
        case let .detail(.userInfoChanged(user)):
            state.users[id: user.id] = user
            return .none
            
        case .detail:
            return .none
        }
    }
)

extension User {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    static var dummy: Self {
        User(firstName: "John", lastName: "Simth", email: "john@gmail.com", age: 14, job: "Student")
    }
}

struct UsersEnvironment {
    var randomFirstName: RandomGenerator.GenerateFirstName
    var cancelGenerator: RandomGenerator.CancelFirstNameGenerator
}

extension UsersEnvironment {
    var userDetail: UserDetailEnvironment {
        .init(userInfo: UserInfoEnvironment())
    }
}
