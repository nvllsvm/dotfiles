if [[ $OSTYPE = "darwin*" ]]; then
    android_home=~/Library/Android
    path=("/Applications/Android Studio 3.0 Preview.app/Contents/jre/jdk/Contents/Home/bin" "$path[@]")
else
    android_home=~/.android
fi

if [[ -d "$android_home" ]]; then
    path+=($android_home/sdk/platform-tools)
    path+=($android_home/sdk/tools)
    path+=($android_home/sdk/tools/bin)
    path+=($android_home/sdk/build-tools/$(ls $android_home/sdk/build-tools 2> /dev/null | tail -n 1))
    path=("$DOTFILES_DIR"/scripts/android "$path[@]")

    export ANDROID_HOME=$android_home/sdk

    if [[ -d "$android_home/sdk/ndk-bundle" ]]; then
        path+=($android_home/sdk/ndk-bundle)
        export ANDROID_NDK_HOME=$android_home/sdk/ndk-bundle
    fi

fi

unset android_home
