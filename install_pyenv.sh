#!/usr/bin/env bash
set -euo pipefail

# ==========
# Settings
# ==========
PYENV_DIR="${HOME}/pyenv"
BASHRC="${HOME}/.bashrc"

echo "[1/6] Installing required packages..."
sudo apt update -y
sudo apt install -y \
  git \
  build-essential \
  zlib1g-dev \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  curl \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev

echo "[2/6] Cloning pyenv into: ${PYENV_DIR}"
if [[ -d "${PYENV_DIR}/.git" ]]; then
  echo "  - pyenv already exists. Updating..."
  git -C "${PYENV_DIR}" pull --ff-only
else
  git clone https://github.com/pyenv/pyenv.git "${PYENV_DIR}"
fi

echo "[3/6] Building pyenv (optional speed-up)..."
if [[ -f "${PYENV_DIR}/src/configure" ]]; then
  (cd "${PYENV_DIR}" && src/configure && make -C src) || true
fi

echo "[4/6] Updating ${BASHRC} (idempotent)..."
# 追記ブロック（重複追記しない）
START_MARK="# >>> pyenv init >>>"
END_MARK="# <<< pyenv init <<<"

if ! grep -qF "${START_MARK}" "${BASHRC}" 2>/dev/null; then
  {
    echo ""
    echo "${START_MARK}"
    echo "export PYENV_ROOT=\"${PYENV_DIR}\""
    echo "command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
    echo "eval \"\$(pyenv init -)\""
    echo "${END_MARK}"
  } >> "${BASHRC}"
  echo "  - Added pyenv init block."
else
  echo "  - pyenv init block already exists. Skipping append."
fi

echo "[5/6] Loading bashrc for current shell (best-effort)..."
# 実行シェルが bash でない場合もあるので best-effort
set +u
source "${BASHRC}" 2>/dev/null || true
set -u

echo "[6/6] Verifying..."
if command -v pyenv >/dev/null 2>&1; then
  pyenv --version
  echo "Done. Open a new shell (or 'source ~/.bashrc') if needed."
else
  echo "pyenv command not found in current session."
  echo "Try: source ~/.bashrc"
  exit 1
fi
