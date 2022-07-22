//
//  UserInfo.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/22.
//

import ComposableArchitecture
import SwiftUI

struct UserInfoView: View {
    let store: Store<UserInfoState, UserInfoAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.viewState)) { viewStore in
            VStack {
                HStack {
                    Text("Frist Name: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(get: \.firstName, send: UserInfoAction.firstNameChanged)
                    )
                }
                
                HStack {
                    Text("Last Name: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(get: \.lastName, send: UserInfoAction.lastNameChanged)
                    )
                }
                
                HStack {
                    Text("Email: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(get: \.email, send: UserInfoAction.emailChanged)
                    ).keyboardType(.emailAddress)
                }
                
                HStack {
                    Text("Age: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(get: \.age, send: UserInfoAction.ageChanged)
                    ).keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Job: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(get: \.job, send: UserInfoAction.jobChanged)
                    )
                }
            }.disabled(viewStore.disabled)
        }
    }
}

extension UserInfoView {
    struct State: Equatable {
        var firstName: String
        var lastName: String
        var email: String
        var age: String
        var job: String
        var disabled: Bool
    }
}

extension UserInfoState {
    var viewState: UserInfoView.State {
        .init(
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            age: String(user.age),
            job: user.job,
            disabled: self.disabled
        )
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(
            store: Store(
                initialState: UserInfoState(
                    user: User.dummy,
                    disabled: true
                ),
                reducer: userInfoReducer,
                environment: UserInfoEnvironment()
            )
        )
    }
}
