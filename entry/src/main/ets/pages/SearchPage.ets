import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { AudioRecorderDemo } from '../Utils/AVRecorder'
import { AvPlayer } from '../Utils/AVPlayer';

function createFile() {
  // 获取应用文件路径
  let context = getContext(this) as common.UIAbilityContext;
  let filesDir = context.filesDir;
  console.log(filesDir, 'filesDir')
  // 新建并打开文件
  let file = fs.openSync(filesDir + '/test.m4a', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  console.log('fs.stat(file.fd)', file.fd)

  return file.fd
}

function deleteFile() {
  // 获取应用文件路径
  let context = getContext(this) as common.UIAbilityContext;
  let filesDir = context.filesDir;
  fs.unlinkSync(filesDir + '/test.m4p');
}

let fileFd: number
@Entry
@Component
struct SearchPage {
  @State txt: string = '录音';
  @State txt2: string = '删除录音'

  build() {
    Column() {
      Text(this.txt).fontSize(30).onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.txt = '录音中'
          const fd = createFile()
          fileFd = fd
          AudioRecorderDemo.startRecordingProcess(fd);
        }
        if (event.type === TouchType.Up) {
          this.txt = '录音';
          AudioRecorderDemo.stopRecordingProcess();
        }
      })

      Text('播放').fontSize(80).onClick(() => {
        AvPlayer.setAVPlayerUrl(`fd://${fileFd}`)
      })

      Text(this.txt2).fontSize(100).onClick(() => {
        deleteFile()
        this.txt2 = '删除成功'
      })
    }
  }
}