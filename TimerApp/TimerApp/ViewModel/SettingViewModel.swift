//
//  SettingViewModel.swift
//  TimerApp
//
//  Created by 藤治仁 on 2021/08/22.
//

import UIKit
import SwiftUI

class SettingViewModel: ObservableObject {
    /// タイマー設定時間
    @Published var isCloseTapped = false
    
    /// 永続化する秒数設定（初期値は10）
    @AppStorage(settingKey) var timerValue = settingDefault
}
