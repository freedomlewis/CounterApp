//
//  UserDetailView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/20.
//

import ComposableArchitecture
import SwiftUI

struct UserDetailView: View {
    let store: Store<UserDetailState, UserDetailAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.viewState)) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Name: ")
                    Text("\(viewStore.name)")
                }
                
                Divider()
                
                HStack {
                    Text("Email: ")
                    Text("\(viewStore.email)")
                }
                
                Divider()
                
                HStack {
                    Text("Age: ")
                    Text("\(viewStore.age)")
                }
                
                Divider()
                
                HStack {
                    Text("Job: ")
                    Text("\(viewStore.job)")
                }
                
                Button("Edit User Info") {
                    viewStore.send(.activeEdit)
                }
                Spacer()
            }
            .padding(.leading)
            .sheet(
                isPresented: viewStore.binding(
                    get: \.isPresent,
                    send: { _ in .deActiveEdit }
                )
            ) {
                IfLetStore(
                    self.store.scope(
                        state: \.editUserState,
                        action: UserDetailAction.edit
                    )
                ) {
                    EditUserView(store: $0)
                }
            }
        }
    }
}

extension UserDetailView {
    struct State: Equatable {
        var name: String
        var email: String
        var age: Int
        var job: String
        var isPresent: Bool
    }
}

extension UserDetailState {
    var viewState: UserDetailView.State {
        .init(
            name: user.fullName,
            email: user.email,
            age: user.age,
            job: user.job,
            isPresent: editUserState != nil
        )
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
