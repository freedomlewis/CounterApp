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

extension User {
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

enum UsersAction: Equatable {
    case detail(UserDetailAction)
    case setNavigation(selection: UUID?)
}

struct UsersEnvironment {}

let usersReducer = Reducer<UsersState, UsersAction, UsersEnvironment> { state, action, _ in
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
    }
}

struct UsersView: View {
    let store: Store<UsersState, UsersAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewStore.users) { user in
                    NavigationLink(
                        destination: IfLetStore(
                            self.store.scope(
                                state: \.selection?.value,
                                action: UsersAction.detail
                            )
                        ) {
                            UserDetailView(store: $0)
                        } else: {
                            ProgressView()
                        },
                        tag: user.id,
                        selection: viewStore.binding(
                            get: \.selection?.id,
                            send: UsersAction.setNavigation(selection:)
                        )
                    ) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("\(user.fullName)").font(.title2)
                            }
                            HStack {
                                Text("\(user.email)").foregroundColor(.gray)
                            }
                        }.padding(.leading)
                    }
                    
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
