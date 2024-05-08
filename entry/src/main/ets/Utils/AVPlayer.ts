import media from '@ohos.multimedia.media';
import fs from '@ohos.file.fs';
import { AppState, StateKey } from './AppStorage';
import { sleep } from './utils';
import { msTransform } from '../Utils/utils';

export enum PlayAudioFrom {
  local = 'local',
  net = 'net',
}

class AVPLAYER {
  public avPlayer;

  // 注册avplayer回调函数
  private setAVPlayerCallback() {
    // seek操作结果回调函数
    this.avPlayer.on('seekDone', (seekDoneTime) => {
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用reset接口触发重置流程
    this.avPlayer.on('error', (err) => {
      console.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      this.avPlayer.reset(); // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    this.avPlayer.on('stateChange', async (state, reason) => {
      console.log(state, 'state1111')
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.');
        // this.avPlayer.release(); // 调用release接口销毁实例对象
          break;
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayerstate initialized called.');
          this.avPlayer.prepare().then(() => {
            console.info('AVPlayer prepare succeeded.');
          }, (err) => {
            console.error(`Invoke prepare failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.');
          this.avPlayer.play(); // 调用播放接口开始播放
          break;
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.');
        // this.avPlayer.pause(); // 调用暂停接口暂停播放
          break;
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.');
        // this.avPlayer.play(); // 再次播放接口开始播放
          break;
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.');
        // this.avPlayer.stop(); //调用播放结束接口
          break;
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.');
        // this.avPlayer.reset(); // 调用reset接口初始化avplayer状态
          break;
        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    })

    this.avPlayer.on('durationUpdate', (duration) => {
      /* 音频总时长转换 */
      const res = msTransform(duration)
      AppState.setState(StateKey.musicDuration, res)
      console.info('durationUpdate success,new duration is :' + duration)
    })
  }

  // 以下demo为使用fs文件系统打开沙箱地址获取媒体文件地址并通过url属性进行播放示例
  public async createAVPlayerInstance() {
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数
    this.setAVPlayerCallback();
    console.log('111111111111111111111')
  }

  // 结束音频
  public async stopPlay() {
    this.avPlayer.reset();
    // 延时100ms 防止avPlayer还没进入idle状态就setUrl
    await sleep();
  }

  // 暂停音频
  public pauseAudio() {
    this.avPlayer.pause();
  }

  // 播放音频
  public async playAudio(path?: string, playAudioFrom?: PlayAudioFrom) {
    // 如果path存在则是播放录制音频，否则是播放正常http协议音频
    if (path) {
      if (playAudioFrom === PlayAudioFrom.local) {
        let fdPath = 'fd://';
        let res = fs.accessSync(path);
        if (!res) {
          console.error(`音频文件不存在：${path}`);
          return
        }
        console.info(`播放音频文件：${path}`)
        // 打开相应的资源文件地址获取fd
        let file = await fs.open(path);
        fdPath = fdPath + '' + file.fd;
        this.avPlayer.url = fdPath;
      } else {
        this.avPlayer.url = path;
      }
    } else {
      this.avPlayer.play();
    }
  }
}

export const AvPlayer = new AVPLAYER()