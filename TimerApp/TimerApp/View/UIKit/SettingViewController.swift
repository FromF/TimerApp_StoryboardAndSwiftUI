//
//  SettingViewController.swift
//  TimerApp
//
//  Created by 藤治仁 on 2021/08/22.
//

import UIKit
import SwiftUI
import Combine

class SettingViewController: UIViewController {
    
    private let settingViewModel = SettingViewModel()
    
    // サブスクライバーをキャンセルするためのインスタンスを保持する変数
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // SwiftUIをUIViewに貼り付ける
        let vc = UIHostingController(rootView: SettingView(settingViewModel: settingViewModel))
        view.addSubview(vc.view)
        
        // SafeArea内の配置するようにAutolayoutを設定する
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        // SettingViewの決定ボタンをタップした時に値が変化変化する、それによってUIViewControllerの画面遷移制御する
        bind()
    }
    
    // MARK: - Bind SwiftUIView
    private func bind() {
        //@Publishedされたプロパティー変数isCloseTappedに$をつけるとパブリッシャーとなる
        self.settingViewModel.$isCloseTapped
            // サブスクライバーに渡すかフィルタリングする（今回は無条件にサブスクライバーに渡す）
            .filter { $0 }
            // サブスクライバー(値を受け取る)を登録する
            .sink(receiveValue: { [unowned self] isCloseTapped in
                if isCloseTapped {
                    // 決定ボタンがタップされたので1つ前のViewControllerに戻る
                    self.navigationController?.popViewController(animated: true)
                }
            })
            // サブスクライバーをキャンセルするためのインスタンスを保持する
            .store(in : &cancellables)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
