# タイマーアプリ
## 概要

書籍[iPhoneアプリ開発集中講座](https://amzn.to/3sTKBEo)にあるStoryboard版タイマーアプリに設定画面をSwiftUI化したプロジェクト

Storyboardで作成したアプリの一部分にSwftUIを部分的に適用したサンプルプロジェクト



## プロジェクトのポイント

このプロジェクトでは、Storyboardの1つのViewController内のViewをSwiftUIで対応しています。

SwiftUI内のボタンなどの操作によって画面遷移をしています。（今回は閉じるボタン）その画面遷移する上で必要なポイントについて記載します。



### ViewControllerの１つのViewとしてSwiftUIを配置する

1. Storyboardの１つのViewController内のViewをSwiftUIとしています。

●SettingViewController.swift `override func viewDidLoad()`

```swift
// SwiftUIをUIViewに貼り付ける
let vc = UIHostingController(rootView: SettingView(settingViewModel: settingViewModel))
view.addSubview(vc.view)
```



2. 次にViewController内に配置したSwiftUIをSafeArea内の領域いっぱいにオートレイアウト設定しています。

●SettingViewController.swift `override func viewDidLoad()`

```swift
// SafeArea内の配置するようにAutolayoutを設定する
vc.view.translatesAutoresizingMaskIntoConstraints = false
vc.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
vc.view.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
vc.view.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
vc.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
```



### SwiftUI内で操作されたことをViewContollerに伝達して画面遷移する

1. ObservableObjectに継承したSettingViewModelクラスをSettingViewController.swiftでインスタンス生成してSwftUIのView `SettingView()`に渡しています。これは、Publisher を提供する Property Wrapperの`@Published`のプロパティー変数を`SettingViewController()`からも参照できるようにするためです。

●SettingViewController.swiftの一部抜粋

```swift
private let settingViewModel = SettingViewModel()

　　　　　　　（省略）

let vc = UIHostingController(rootView: SettingView(settingViewModel: settingViewModel))
```



2. SwiftUIで閉じるボタンをタップすると`@Published var isCloseTapped`の値を`toggle()`メソッドを実行して`false`→`true`に書き換えます。

●SettingView.swift `SettingView()`

```swift
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
```



3. `@Published var isCloseTapped`がcombineのパブリッシャーとなるのでサブスクライバーを`SettingViewController()`で作成し、閉じるボタンをタップされたら画面遷移するようにする。

●SettingViewController.swift `private func bind()`

```swift
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
```



## 参考

- [【Swift】Combineフレームワーク使ってみた 〜 その１ 〜 超シンプルな例](https://youtu.be/n-vnggqiAPU)
- [【Swift】Combineフレームワーク使ってみた 〜 その２ 〜 オペレーター](https://youtu.be/z45a26JJSbU)
- [【Swift】Combine フレームワーク使ってみた 〜 その３ 〜 Notification](https://youtu.be/ddS-ckbSuj0)
- [【Swift】 Combine フレームワーク使ってみた 〜 その４ 〜 URLSession](https://youtu.be/e24TnooPhes)
- [【SwiftUI】Combine フレームワーク使ってみた 〜 その５ 〜 SwiftUI で天気予報を表示](https://youtu.be/zp_YQkdDtH8)

- [[SwiftUI][Combine] @Published は、Publisher を提供する Property Wrapper](https://software.small-desk.com/development/2021/02/17/swift-combine-atpublished-publisher/)

- [そろそろCombine iOSDC Japan 2020](https://fortee.jp/iosdc-japan-2020/proposal/3338e9cc-da3e-462c-951a-6ebe9f8664f4)

