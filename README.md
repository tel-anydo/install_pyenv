# install_pyenv.sh

# pyenv インストール一括スクリプト（Ubuntu / Debian）

Ubuntu / Debian 系環境で **pyenv のインストールと初期設定を一括で行うためのスクリプト** です。  
公式手順で必要となる依存パッケージの導入、pyenv の clone、ビルド、高速化、`.bashrc` への設定追記までを自動化しています。

---

## 対応環境

- Ubuntu 20.04 / 22.04 / 24.04
- Debian 系 Linux
- シェル: **bash**

※ zsh を使用している場合は `.bashrc` ではなく `.zshrc` への追記に変更してください。

---

## このスクリプトで行うこと

1. pyenv ビルドに必要な依存パッケージのインストール  
2. pyenv を `~/pyenv` に clone（既存の場合は update）  
3. pyenv のビルド（高速化用、失敗しても処理継続）  
4. `~/.bashrc` に pyenv 初期化設定を追記（重複防止あり）  
5. pyenv が正しく動作するか確認  

---

## インストール方法

### 方法1: clone して実行（推奨）

```bash
git clone https://github.com/tel-anydo/install_pyenv.git
cd install_pyenv
bash install_pyenv.sh
