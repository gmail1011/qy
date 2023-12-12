git地址:https://github.com/mcxiaoke/packer-ng-plugin

命令:java -jar packer-ng-2.0.1.jar generate --channels=test1,test2 --output=archives ../../dist/yuehui_relese_2020_06_07_18:08_1.0.12+21.apk

packer-ng - 表示 java -jar packer-ng-2.0.1.jar
channels.txt - 替换成你的渠道列表文件的实际路径
build/archives - 替换成你指定的渠道包的输出路径
app.apk - 替换成你要打渠道包的APK文件的实际路径
直接指定渠道列表打包：
packer-ng generate --channels=ch1,ch2,ch3 --output=build/archives app.apk
指定渠道列表文件打包：
packer-ng generate --channels=@channels.txt --output=build/archives app.apk
验证渠道信息：
packer-ng verify app.apk
运行命令查看帮助
java -jar tools/packer-ng-2.0.1.jar --help
Python脚本读取渠道：
python tools/packer-ng-v2.py app.apk