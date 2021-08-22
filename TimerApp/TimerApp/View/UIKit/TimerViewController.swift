//
//  TimerViewController.swift
//  TimerApp
//
//  Created by 藤治仁 on 2021/08/22.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    /// タイマーの変数
    private var timer : Timer?
    /// カウント(経過時間)
    private var count = 0
    
    /// タイマー実行中状態を取得
    private var timerIsValid: Bool {
        // timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            if nowTimer.isValid == true {
                // タイマー実行中
                return true
            }
        }
        
        return false
    }
    
    /// タイマー設定時間
    private var timerValue: Int {
        // UserDefaultsに初期値を登録
        UserDefaults.standard.register(defaults: [settingKey:settingDefault])
        // タイマーの設定値を取得
        return UserDefaults.standard.integer(forKey: settingKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // 画面切り替えのタイミングで処理を行なう
    override func viewDidAppear(_ animated: Bool) {
        // カウント(経過時間)をゼロにする
        count = 0
        // タイマーの表示を更新する
        _ = displayUpdate()
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
        // もしタイマーが、実行中だったら停止
        if timerIsValid == true {
            // タイマー停止
            timer?.invalidate()
        }
        
        // 画面遷移を行う
        performSegue(withIdentifier: "SettingViewController", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        // もしタイマーが、実行中だったらスタートしない
        if timerIsValid == true {
            // 何も処理しない
            return
        }
        
        // タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        // もしタイマーが、実行中だったら停止
        if timerIsValid == true {
            // タイマー停止
            timer?.invalidate()
        }
    }
    
    /// 画面の更新をする
    /// - Returns: 残り時間
    private func displayUpdate() -> Int {
        // 残り時間(remainCount)を生成
        let remainCount = timerValue - count
        // remainCount(残りの時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        // 残り時間を戻り値に設定
        return remainCount
    }
    
    /// 経過時間の処理
    /// - Parameter timer: Timerクラスのインスタンス
    @objc private func timerInterrupt(_ timer:Timer) {
        // count(経過時間)に+1していく
        count += 1
        // remainCount(残り時間)が0以下のとき、タイマーを止める
        if displayUpdate() <= 0 {
            // 初期化処理
            count = 0
            // タイマー停止
            timer.invalidate()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

