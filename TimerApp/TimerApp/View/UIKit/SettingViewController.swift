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
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // SwiftUIをUIViewに貼り付ける
        let vc: UIHostingController = UIHostingController(rootView: SettingView(settingViewModel: settingViewModel))
        view.addSubview(vc.view)
        
        // SafeArea内の配置するようにAutolayoutを設定する
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        vc.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        vc.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        // SwiftUIViewと繋ぐ
        bind()
    }
    
    // MARK: - Bind SwiftUIView
    private func bind() {
        self.settingViewModel.$isCloseTapped
            .filter { $0 }
            .sink { [unowned self] _ in
                // 決定ボタンがタップされたので1つ前のViewControllerに戻る
                self.navigationController?.popViewController(animated: true)
            }
            .store(in : &cancellables)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
