#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    printf -- "Build Paofu_Yinse release package.\n\n"
    printf -- "Usage: $0 <target>  a:apk | i:ios | all:api and ios \n"
    exit
fi

ver=`grep 'version:' pubspec.yaml`
ver=${ver##'version: '}
time=$(date "+%y%m%d")
echo "> Check version from 'pubspec.yaml': '$ver'."

if [ ! -d './dist'  ];then
  echo "> Make dir './dist'."
  mkdir './dist'
fi

checkEnv() {
  key=$1
  script_dir=$( cd "$( dirname "$0"  )" && pwd )
  script_name=$(basename ${0})
  keyPath=${script_dir}$2
  line=`grep "$key" $keyPath`
  echo ">>>>>>>>>>>>>>>>>>>>>>>"
  echo ">$line"
  echo ">>>>>>>>>>>>>>>>>>>>>>>"
  echo ">Are you sure? (Press any key to continue.)"
  read aChar
  # while read line; do
  #   # if [ "$config" = echo $line|awk '{print $config}' ];then
  #   if [[ line =~ $config ]];then
  #      echo "the $config 's find in line is `echo $line|awk '{print $2}'`" 
  #      break;  
  #   fi
  #   # echo "${line}"
  # done
}

# test() {
#   echo "> Building apk."
# }

android() {
  # test;
  checkEnv "innerVersion =" "/lib/common/config/config.dart";
  checkEnv "DEBUG =" "/lib/common/config/config.dart";
  checkEnv "PROXY =" "/lib/common/config/config.dart";
  echo "> Now begin building apk."
  flutter build apk --target-platform android-arm --shrink --obfuscate --split-debug-info=./build/debuginfo

  # 服务器批量打包需求，请按照 “项目_日期_版本.apk来命名，日期不能包含下划线
  echo "> Coping apk to dist."
  mv ./build/app/outputs/apk/release/app-release.apk ./dist/'ys_'$time'_'$ver'.apk'

  echo '> Built apk done. path:./dist/ys_'$time'_'$ver'.apk'
}


ios() {
  echo "> Building ios by flutuer."
  flutter build ios --obfuscate --split-debug-info=./build/debuginfo


  echo "> Building ios by xcode."
  xcodebuild -quiet -workspace ./ios/Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath ./build/ios/Runner.xcarchive

  echo "> export ipa."
  xcodebuild -quiet -exportArchive -archivePath ./build/ios/Runner.xcarchive -exportPath ./build/ios -exportOptionsPlist ./ios/ExportOptions.plist

  mv ./build/ios/Runner.ipa ./dist/im_$ver.ipa

  echo "> Built ios done. './dist/im_$ver.ipa'"
}


case "$1" in
  a)   android;;
  i)   ios;;
  all) android;ios;;
  *)   printf -- '\n';exit;;
esac

printf -- '\n'
# cd ${p_path}
# git pull


# echo "> Start commit to git..."
# cd ${p_path}
# git pull
# git add .
# git commit -m "IM Android online release [$1]"
# git push
# echo "> Commit to git completed..."
