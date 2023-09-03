//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/11.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView()
                .navigationBarTitle("设置")
        }
    }
}

#if DEBUG
struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView().environmentObject(Store.sample)
    }
}
#endif
