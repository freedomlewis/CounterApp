//
//  UserDetailView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/20.
//

import ComposableArchitecture
import SwiftUI

struct UserDetailState: Equatable {
    var user: User
}

struct UserDetailAction {}

struct UserDetailEnvironment {}

let userDetailReducer = Reducer<UserDetailState, UserDetailAction, UserDetailEnvironment> { _, action, _ in
    switch action {
    default:
        return .none
    }
}

struct UserDetailView: View {
    let store: Store<UserDetailState, UserDetailAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.user)) { user in
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Name: ")
                    Text("\(user.fullName)")
                }
                
                Divider()
                
                HStack {
                    Text("Age: ")
                    Text("\(user.age)")
                }
                
                Divider()
                
                HStack {
                    Text("Job: ")
                    Text("\(user.job)")
                }
                
                Divider()
                
                HStack {
                    Text("Email: ")
                    Text("\(user.email)")
                }
            }
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(
            store: Store(
                initialState: UserDetailState(
                    user: User(
                        firstName: "David",
                        lastName: "Smith",
                        email: "david@gmail.com",
                        age: 60,
                        job: "Farmer"
                    )
                ),
                reducer: userDetailReducer,
                environment: UserDetailEnvironment()
            )
        )
    }
}
