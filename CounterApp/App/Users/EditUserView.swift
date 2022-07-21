//
//  EditUserView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import SwiftUI

struct EditUserState: Equatable {
    var user: User
}

enum EditUserAction: Equatable {
    case firstNameChanged(String)
    case lastNameChanged(String)
    case emailChanged(String)
    case ageChanged(String)
    case jobChanged(String)
    case onSaveTapped
    case onCancelTapped
}

struct EditUserEnvironment {}

let editUserReducer = Reducer<EditUserState, EditUserAction, EditUserEnvironment> { state, action, _ in
    switch action {
    case let .firstNameChanged(firstName):
        state.user.firstName = firstName
        return .none
        
    case let .lastNameChanged(lastName):
        state.user.lastName = lastName
        return .none
        
    case let .emailChanged(email):
        state.user.email = email
        return .none
        
    case let .ageChanged(age):
        state.user.age = Int(age) ?? 0
        return .none
        
    case let .jobChanged(job):
        state.user.job = job
        return .none
        
    default:
        return .none
    }
}

struct EditUserView: View {
    let store: Store<EditUserState, EditUserAction>
    
    var body: some View {
        WithViewStore(self.store.scope(state: \.viewState)) { viewStore in
            VStack{
                HStack{
                    Button("Cancel") { viewStore.send(.onCancelTapped) }
                    
                    Spacer()
                    
                    Button("Save") { viewStore.send(.onSaveTapped) }
                }
                
                VStack {
                    HStack{
                        Text("Frist Name: ").padding(.trailing)
                        TextField(
                            "",
                            text: viewStore.binding(get: \.firstName, send: EditUserAction.firstNameChanged)
                        )
                    }
                    
                    HStack{
                        Text("Last Name: ").padding(.trailing)
                        TextField(
                            "",
                            text: viewStore.binding(get: \.lastName, send: EditUserAction.lastNameChanged)
                        )
                    }
                    
                    HStack{
                        Text("Email: ").padding(.trailing)
                        TextField(
                            "",
                            text: viewStore.binding(get: \.email, send: EditUserAction.emailChanged)
                        ).keyboardType(.emailAddress)
                    }
                    
                    HStack{
                        Text("Age: ").padding(.trailing)
                        TextField(
                            "",
                            text: viewStore.binding(get: \.age, send: EditUserAction.ageChanged)
                        ).keyboardType(.numberPad)
                    }
                    
                    HStack{
                        Text("Job: ").padding(.trailing)
                        TextField(
                            "",
                            text: viewStore.binding(get: \.job, send: EditUserAction.jobChanged)
                        )
                    }
                }
                
                Spacer()
            }.padding()
        }
    }
}

extension EditUserView {
    struct State: Equatable {
        var firstName: String
        var lastName: String
        var email: String
        var age: String
        var job: String
    }
    
    struct Environment {}
}

extension EditUserState {
    var viewState: EditUserView.State {
        .init(
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.email,
            age: String(user.age),
            job: user.job
        )
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView(
            store: Store(
                initialState: EditUserState(
                    user: User(
                        firstName: "Bill",
                        lastName: "Gates",
                        email: "bill@gmail.com",
                        age: 0,
                        job: "CEO"
                    )
                ),
                reducer: editUserReducer,
                environment: EditUserEnvironment()
            )
        )
    }
}
