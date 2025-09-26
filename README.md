# MinQ

MinQ（ミンク）は、毎日3タップで続くミニクエ習慣化アプリです。匿名ペアとハイファイブを送り合いながら、勉強・運動・セルフケアなどのちいさな行動を積み重ねられます。

## 主な機能
- 50件の日本語テンプレート＋カスタムミニクエ登録
- 写真 or 自己申告で完了できる3ステップ記録（オフライン対応）
- 連続日数・最長ストリーク／30日ヒートマップ可視化
- 匿名ペアのランダムマッチ＆招待コード、1日1回のハイファイブ
- 朝・夜＋補助の最大3回リマインダーと自動同期

## アーキテクチャ
- Flutter 3 / Riverpod / GoRouter
- ローカル永続化に Isar、クラウド同期に Firebase Firestore
- 通知は flutter_local_notifications + timezone、画像保存は端末ディレクトリ

## セットアップ
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

Firebase を利用する場合は `flutterfire configure` で `firebase_options.dart` を再生成してください。

## テスト
```bash
flutter analyze
flutter test
```

## リリースメモ
- 0.9.0: MVP機能を実装。日本語UI刷新、匿名ペア機能と通知を強化。

## ライセンス
本リポジトリは個人開発プロジェクトです。商用利用や再配布を行う場合は作者までご連絡ください。
