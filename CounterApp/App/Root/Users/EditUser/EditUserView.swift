//
//  EditUserView.swift
//  CounterApp
//
//  Created by Wenjuan Li on 2022/7/21.
//

import ComposableArchitecture
import SwiftUI

struct EditUserView: View {
    let store: Store<EditUserState, EditUserAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack{
                HStack{
                    Button("Cancel") { viewStore.send(.onCancelTapped) }
                    
                    Spacer()
                    
                    Button("Save") { viewStore.send(.onSaveTapped) }
                }
                
                UserInfoView(store: self.store.scope(state: \.userInfo, action: EditUserAction.userInfoView))
                
                Spacer()
            }.padding()
        }
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView(
            store: Store(
                initialState: EditUserState(user: User.dummy),
                reducer: editUserReducer,
                environment: EditUserEnvironment(userInfo: UserInfoEnvironment())
            )
        )
    }
}
