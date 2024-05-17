import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { checkPermissions, reqPermissionsAndRecord } from '../../utils/Permission';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { AVRecorder } from '../../Utils/AVRecorder'
import { AvPlayer, PlayAudioFrom } from '../../Utils/AVPlayer';
import request from '@ohos.request';
import { BASE_URL } from '../../const';
import { showToast } from '../../Utils/utils';
import { AppState, PersistentKey } from '../../Utils/AppStorage';
import router from '@ohos.router';

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

@Component
export struct Record {
  @StorageLink('userId') userId: string = ''
  @State title: string = ''
  @State recordTouch: boolean = false
  @State recordBtnText: string = '按下录音'
  @State playBtnText: string = '播放音频'
  private playIng: boolean = false;

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Text('上传')
          .fontSize(18)
          .fontWeight(500)
          .width('100%')
          .textAlign(TextAlign.End)
          .onClick(async () => {
            if(!AppState.getState(PersistentKey.token)) {
              showToast('需要先登录')
              setTimeout(() => {
                router.pushUrl({url: "pages/Login"})
              }, 1500)
              return;
            }

            if(!this.title) {
              showToast('请填写录音名称')
              return;
            }
            console.log('发送文件txt')
            // 获取应用文件路径
            let cacheDir = context.cacheDir;

            await fs.copyFile(audioPath, cacheDir + '/audio.m4a')

            // 新建一个本地应用文件
            // let file = fs.openSync(cacheDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            // fs.writeSync(file.fd, 'upload file test');
            // fs.closeSync(file);

            // 上传任务配置项
            let uploadConfig = {
              url: `${BASE_URL}music/${this.userId}/upload`,
              header: { key1: 'Content-Type', key2: 'multipart/form-data' },
              method: 'POST',
              files: [
                { filename: 'audio.m4a', name: 'file', uri: 'internal://cache/audio.m4a', type: 'm4a' }
              // { filename: 'test.txt', name: 'file', uri: 'internal://cache/test.txt', type: 'txt' }
              ],
              data: [
                { name: 'name', value: this.title }
              ]
            }

            // 将本地应用文件上传至网络服务器
            try {
              request.uploadFile(context, uploadConfig)
                .then((uploadTask) => {
                  uploadTask.on('complete', (taskStates) => {
                    for (let i = 0; i < taskStates.length; i++) {
                      console.info(`upload complete taskState: ${JSON.stringify(taskStates[i])}`);
                    }
                  });
                })
                .catch((err) => {
                  console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
                })
            } catch (err) {
              console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
            }
          })
      }

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        TextInput({ text: this.title, placeholder: '专辑名称...' })
          .height(40)
          .borderRadius(0)
          .onChange((value) => {
            this.title = value
          })
        Image($r("app.media.defaultCover"))
          .width("100%")

        Image($r("app.media.record"))
          .margin({ top: 20 })
          .width(100)
          .opacity(this.recordTouch ? 0.7 : 1)
          .onTouch((event) => {
            switch (event.type) {
              case TouchType.Down:
                this.recordTouch = true
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
                this.recordTouch = false
                console.info('松开按钮')
                if (AVRecorder != null) {
                  // 停止录音
                  AVRecorder.stopRecord()
                }
                this.recordBtnText = '按下录音'
                break
            }
          })
      }
      .margin({ top: 100 })
      // .height(490)
    }
    .width("100%")
    .height("100%")
    .padding(20)
    // Flex({direction: FlexDirection.Column}) {
    //   // 测试网络
    //   Button('发送文件txt').onClick(async (event: ClickEvent) => {
    //     console.log('发送文件txt')
    //     // 获取应用文件路径
    //     let cacheDir = context.cacheDir;
    //
    //     await fs.copyFile(audioPath, cacheDir + '/audio.m4a')
    //
    //     // 新建一个本地应用文件
    //     // let file = fs.openSync(cacheDir + '/test.txt', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    //     // fs.writeSync(file.fd, 'upload file test');
    //     // fs.closeSync(file);
    //
    //     // 上传任务配置项
    //     let uploadConfig = {
    //       url: `${BASE_URL}music/upload`,
    //       header: { key1: 'Content-Type', key2: 'multipart/form-data' },
    //       method: 'POST',
    //       files: [
    //         { filename: 'audio.m4a', name: 'file', uri: 'internal://cache/audio.m4a', type: 'm4a' }
    //       // { filename: 'test.txt', name: 'file', uri: 'internal://cache/test.txt', type: 'txt' }
    //       ],
    //       data: [
    //         { name: 'name', value: 'value123123' }
    //       ]
    //     }
    //
    //     // 将本地应用文件上传至网络服务器
    //     try {
    //       request.uploadFile(context, uploadConfig)
    //         .then((uploadTask) => {
    //           uploadTask.on('complete', (taskStates) => {
    //             for (let i = 0; i < taskStates.length; i++) {
    //               console.info(`upload complete taskState: ${JSON.stringify(taskStates[i])}`);
    //             }
    //           });
    //         })
    //         .catch((err) => {
    //           console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
    //         })
    //     } catch (err) {
    //       console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
    //     }
    //   })
    //   // 录音按钮
    //   Button(this.recordBtnText)
    //     .id('btn1')
    //     .width('90%')
    //     .margin({ bottom: 10 })
    //     // .alignRules({
    //     //   bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
    //     //   middle: { anchor: '__container__', align: HorizontalAlign.Center }
    //     // })
    // .onTouch((event) => {
    //   switch (event.type) {
    //     case TouchType.Down:
    //       console.info('按下按钮')
    //     // 判断是否有权限
    //       let promise = checkPermissions(permissions[0])
    //       promise.then((result) => {
    //         if (result) {
    //           // 开始录音
    //           AVRecorder.startRecord(audioPath)
    //           this.recordBtnText = '录音中...'
    //         } else {
    //           console.log('获取权限失败')
    //           // 申请权限
    //           reqPermissionsAndRecord(context, permissions)
    //         }
    //       })
    //       break
    //     case TouchType.Up:
    //       console.info('松开按钮')
    //       if (AVRecorder != null) {
    //         // 停止录音
    //         AVRecorder.stopRecord()
    //       }
    //       this.recordBtnText = '按下录音'
    //       break
    //   }
    // })
    //
    //   // 录音按钮
    //   Button(this.playBtnText)
    //     .id('btn2')
    //     .width('90%')
    //     .margin({ bottom: 10 })
    //     // .alignRules({
    //     //   bottom: { anchor: 'btn1', align: VerticalAlign.Top },
    //     //   middle: { anchor: '__container__', align: HorizontalAlign.Center }
    //     // })
    //     .onClick(async () => {
    //       if (!this.playIng) {
    //         // 播放音频
    //         await AvPlayer.stopPlay()
    //         AvPlayer.playAudio(audioPath, PlayAudioFrom.local)
    //         this.playIng = true
    //         this.playBtnText = '播放中...'
    //       } else {
    //         // 停止播放
    //         AvPlayer.stopPlay()
    //         this.playIng = false
    //         this.playBtnText = '播放'
    //       }
    //     })
    // }
    // .width('100%')
    // .height('100%')
  }
}
