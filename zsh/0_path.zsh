# path, the 0 in the filename causes this to load first
path=(
  $path
  $HOME/.yadr/bin
  $HOME/.yadr/bin/yadr
)

export PATH="$PATH:./node_modules/.bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"
export PATH="/Users/auser/.evm/bin:$PATH"
export PATH="/usr/local/dev-env/bin:$PATH"
export DYLD_LIBRARY_PATH="/usr/local/cuda/lib:$DYLD_LIBRARY_PATH"
