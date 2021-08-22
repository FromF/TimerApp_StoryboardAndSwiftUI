//
//  SettingView.swift
//  TimerApp
//
//  Created by 藤治仁 on 2021/08/22.
//

import SwiftUI

struct SettingView: View {
    @ObservedObject private var settingViewModel: SettingViewModel
    
    init(settingViewModel: SettingViewModel) {
        self.settingViewModel = settingViewModel
    }
    
    var body: some View {
        // 奥から手前方向にレイアウト
        ZStack {
            // 背景色表示
            Color("backgroundSetting")
            
            // 垂直にレイアウト(縦方向にレイアウト)
            VStack {
                // スペースを空ける
                Spacer()
                
                // テキストを表示する
                Text("\(settingViewModel.timerValue)秒")
                    // 文字サイズを指定
                    .font(.largeTitle)
                
                // スペースを空ける
                Spacer()
                
                // 閉じるボタン
                Button(action: {
                    // CLOSEフラグを立てる
                    settingViewModel.isCloseTapped.toggle()
                }) {
                    // テキストを表示する
                    Text("決定")
                        // 文字サイズを指定
                        .font(.title)
                        // 文字色を白に指定
                        .foregroundColor(Color.white)
                        // 幅高さを140に指定
                        .frame(width: 140, height: 140)
                        // 背景を設定
                        .background(Color(.gray))
                        // 円形に切り抜く
                        .clipShape(Circle())

                }
                
                // スペースを空ける
                Spacer()
                
                // Pickerを表示
                Picker(selection: settingViewModel.$timerValue, label: Text("選択")) {
                    Text("10")
                        .tag(10)
                    Text("20")
                        .tag(20)
                    Text("30")
                        .tag(30)
                    Text("40")
                        .tag(40)
                    Text("50")
                        .tag(50)
                    Text("60")
                        .tag(60)
                }
                
                // スペースを空ける
                Spacer()
            }  // VStack ここまで
        }  // ZStack ここまで
    }  // body ここまで
}  // SettingView ここまで

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let settingViewModel = SettingViewModel()
        SettingView(settingViewModel: settingViewModel)
    }
}
