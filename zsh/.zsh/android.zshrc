if [[ $(uname) = "Darwin" ]]; then
    android_home=~/Library/Android
else
    android_home=~/.android
fi

path+=($android_home/sdk/platform-tools)
path+=($android_home/sdk/tools)
path+=($android_home/sdk/tools/bin)
path+=($android_home/sdk/build-tools/$(ls $android_home/sdk/build-tools | tail -n 1))
export ANDROID_HOME=$android_home/sdk

if [[ -d "$android_home/sdk/ndk-bundle" ]]; then
    path+=($android_home/sdk/ndk-bundle)
    export ANDROID_NDK_HOME=$android_home/sdk/ndk-bundle
fi

unset android_home
