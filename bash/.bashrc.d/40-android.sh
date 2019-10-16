# android sdk
if [ -d "${HOME}/sdk/" ]; then  
  export ANDROID_HOME="$HOME/sdk"
  PATH=${PATH}:${HOME}/sdk/tools
  PATH=${PATH}:${HOME}/sdk/tools/bin
  PATH=${PATH}:${HOME}/sdk/platform-tools
  PATH=${PATH}:${HOME}/sdk/build-tools/25.0.3
fi
