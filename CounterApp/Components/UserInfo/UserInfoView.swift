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
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    Text("Frist Name: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(\UserInfoState.$user.firstName)
                    )
                }
                
                HStack {
                    Text("Last Name: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(\UserInfoState.$user.lastName)
                    )
                }
                
                HStack {
                    Text("Email: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(\UserInfoState.$user.email)
                    ).keyboardType(.emailAddress)
                }
                
                HStack {
                    Text("Age: ").padding(.trailing)
                    TextField(
                        "",
                        value: viewStore.binding(\UserInfoState.$user.age),
                        formatter: NumberFormatter()
                    ).keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Job: ").padding(.trailing)
                    TextField(
                        "",
                        text: viewStore.binding(\UserInfoState.$user.job)
                    )
                }
            }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(
            store: Store(
                initialState: UserInfoState(user: User.dummy),
                reducer: userInfoReducer,
                environment: UserInfoEnvironment()
            )
        )
    }
}
