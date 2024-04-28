import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { checkPermissions, reqPermissionsAndRecord } from '../utils/Permission';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { AVRecorder } from '../Utils/AVRecorder'
import { AvPlayer } from '../Utils/AVPlayer';

// 需要动态申请的权限
const permissions: Array<Permissions> = ['ohos.permission.MICROPHONE'];
// 获取程序的上下文
const context = getContext(this) as common.UIAbilityContext;
// 获取项目的files目录
const filesDir = context.filesDir;
// 如果文件夹不存在就创建
fs.access(filesDir, (err, res: boolean) => {
  if (!res) {
    fs.mkdirSync(filesDir)
  }
});

// 录音文件路径
let audioPath = filesDir + "/audio.m4a";
console.log(audioPath, 'audioPath');

function deleteFile() {
  // 获取应用文件路径
  let context = getContext(this) as common.UIAbilityContext;
  let filesDir = context.filesDir;
  fs.unlinkSync(filesDir + '/audio.m4a');
}

@Entry
@Component
struct SearchPage {
  @State recordBtnText: string = '按下录音'
  @State playBtnText: string = '播放音频'
  private playIng: boolean = false;

  build() {
    Row() {
      RelativeContainer() {
        // 录音按钮
        Button(this.recordBtnText)
          .id('btn1')
          .width('90%')
          .margin({ bottom: 10 })
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onTouch((event) => {
            switch (event.type) {
              case TouchType.Down:
                console.info('按下按钮')
              // 判断是否有权限
                let promise = checkPermissions(permissions[0])
                promise.then((result) => {
                  if (result) {
                    // 开始录音
                    AVRecorder.startRecord(audioPath)
                    this.recordBtnText = '录音中...'
                  } else {
                    console.log('获取权限失败')
                    // 申请权限
                    reqPermissionsAndRecord(context, permissions)
                  }
                })
                break
              case TouchType.Up:
                console.info('松开按钮')
                if (AVRecorder != null) {
                  // 停止录音
                  AVRecorder.stopRecord()
                }
                this.recordBtnText = '按下录音'
                break
            }
          })

        // 录音按钮
        Button(this.playBtnText)
          .id('btn2')
          .width('90%')
          .margin({ bottom: 10 })
          .alignRules({
            bottom: { anchor: 'btn1', align: VerticalAlign.Top },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            if (!this.playIng) {
              // 播放音频
              AvPlayer.playAudio(audioPath)
              this.playIng = true
              this.playBtnText = '播放中...'
            } else {
              // 停止播放
              AvPlayer.stopPlay()
              this.playIng = false
              this.playBtnText = '播放'
            }
          })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}
