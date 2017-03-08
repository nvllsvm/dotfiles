if [[ $(uname) = "Darwin" ]]; then
    android_home=~/Library/Android
else
    android_home=~/.android
fi

path+=($android_home/sdk/platform-tools)
path+=($android_home/sdk/tools)
path+=($android_home/sdk/ndk-bundle)
path+=($android_home/sdk/build-tools/$(ls $android_home/sdk/build-tools | tail -n 1))
export ANDROID_HOME=$android_home/sdk
export ANDROID_NDK_HOME=$android_home/sdk/ndk-bundle

unset android_home
