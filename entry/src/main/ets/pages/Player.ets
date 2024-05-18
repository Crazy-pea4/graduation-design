import { MockData } from '../const/mock';
import { AppState, PersistentKey, StateKey } from '../Utils/AppStorage';
import { AvPlayer } from '../Utils/AVPlayer';
import { storage } from '../Utils/LocalStorage';
import { toUnicodeFun } from '../Utils/utils';
import { MList } from "../type/index"
import router from '@ohos.router';
import { httpRequestPost } from '../Utils/HttpRequest';
import request from '@ohos.request';

@Entry(storage)
@Component
struct Player {
  @State isSliderDrag: boolean = false
  @State dragCurrentPercent: number = 0
  @StorageLink('musicId') musicId: string = ''
  @StorageLink('musicTitle') musicTitle: string = ''
  @StorageLink('musicAuthor') musicAuthor: string = ''
  @StorageLink('musicPicUrl') musicPicUrl: string = ''
  @StorageLink('isPlaying') isPlaying: boolean = false
  @StorageLink('isLiked') isLiked: boolean = false
  @StorageLink('musicDuration') musicDuration: string = '00:00'
  @StorageLink('musicUrl') musicUrl: string = ''
  @StorageLink('duration') duration: number = 0
  @StorageLink('musicTime') musicTime: number = 0
  // 是否是本地下载音乐
  @State isDownloadMusic: boolean = !this.musicUrl.startsWith('http')
  // 初始时代表musicList的倒数第1位
  @State mustLastIndex: number = JSON.parse(AppState.getState(PersistentKey.musicList)).length - 1

  onPageShow() {
    // const ms = AppState.getState<number>(StateKey.musicDuration) || 0
    // const res = msTransform(ms)
    // this.duration = res

    // if (this.isPlaying) {
    //   animateTo({
    //     duration: 10000,
    //     curve: Curve.Linear,
    //     iterations: -1, // 设置-1表示动画无限循环
    //   }, () => {
    //     this.angleA = 360
    //   })
    // }
  }

  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, direction: FlexDirection.Column }) {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.musicPicUrl || "")
          .width(250)
          .height(250)
          .borderRadius(200)
          .animation({ duration: 2000 })
        // .rotate({
        //   angle: this.angleA
        // })
      }
      .width('100%')
      .height('330vp')
      .backgroundColor("#aadff1f1")

      // 操作icon
      Flex({ justifyContent: FlexAlign.End }) {
        Image(this.isLiked ? $r("app.media.red_like") : $r("app.media.grey_like"))
          .width(20)
          .onClick(async () => {
            const {code} = await httpRequestPost(`user/${this.musicId}/music`, {}, false, true)
            if (code === 200) {
              this.isLiked = !this.isLiked
            }
          })
        Image($r("app.media.share"))
          .margin({ left: 10, right: 10 })
          .width(20)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Share' })
          })
        Text("下载")
          .onClick(async () => {
            const unicode = toUnicodeFun(`${this.musicTitle}_${this.musicAuthor}`)
            const DownloadTask = await request.downloadFile(getContext(this), {
              url: this.musicUrl,
              filePath: `${getContext(this).tempDir}/${unicode}_music.mp3`,
              background: true
            })
            DownloadTask.on('complete', () => {
              console.log('request.downloadFile complete')
            })
            DownloadTask.on('fail', () => {
              console.log('request.downloadFile fail')
            })
          })
      }
      .margin({ top: 20, bottom: 20 })
      .visibility(this.isDownloadMusic ? Visibility.Hidden : Visibility.Visible)

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        // 音乐名称和作者
        Flex({ direction: FlexDirection.Column }) {
          Text(this.musicTitle || '暂无标题')
            .margin({ bottom: 8 })
            .fontWeight(700)
          Text(this.musicAuthor || '暂无作者')
            .fontSize(15)
        }

        // 音乐总时长
        Text(this.musicDuration)
      }
      .width('100%')
      .height(50)

      Column() {
        Slider({ value: this.isSliderDrag ? this.dragCurrentPercent : (this.musicTime / this.duration * 100) })
          .selectedColor('black')
          .trackThickness(3)
          .onChange((progress, mode) => {
            switch (mode) {
              case SliderChangeMode.Begin: {
                // 为了防止拖动的时候还在不断计算当前播放百分比，造成停止拖动时滑点会闪现的问题
                this.isSliderDrag = true
                this.dragCurrentPercent = this.musicTime / this.duration * 100
                break;
              }

              case SliderChangeMode.Click:
              case SliderChangeMode.End: {
                this.dragCurrentPercent = this.musicTime / this.duration * 100
                console.log(progress + 'progress111')
                const seekNum = (progress / 100) * this.duration
                AvPlayer.seekAudio(seekNum)
                this.isSliderDrag = false
                break;
              }
              default:
                break;
            }
          })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Image($r("app.media.previous_icon"))
          .width(50)
          .height(50)
          .onClick(async () => {
            const musicList = JSON.parse(AppState.getState(PersistentKey.musicList) || '') as MList[]
            if (this.mustLastIndex <= 0) return
            this.mustLastIndex--
            const previousMusic = musicList[this.mustLastIndex]

            await AvPlayer.stopPlay()
            this.musicTitle = previousMusic.name
            this.musicAuthor = previousMusic.author
            this.musicPicUrl = previousMusic.picUrl
            this.isPlaying = true
            if(previousMusic.url.startsWith('http')) {
              this.isDownloadMusic = false
            } else {
              this.isDownloadMusic = true
            }
            AvPlayer.playAudio(previousMusic.url)
          })
        Image(this.isPlaying ? $r("app.media.main_pause") : $r("app.media.main_play"))
          .width(50)
          .height(50)
          .onClick(() => {
            if (this.isPlaying) {
              AvPlayer.pauseAudio()
              this.isPlaying = false
            } else {
              AvPlayer.playAudio()
              this.isPlaying = true
            }
          })
        Image($r("app.media.next_icon"))
          .width(50)
          .height(50)
          .onClick(async () => {
            const musicList = JSON.parse(AppState.getState(PersistentKey.musicList) || '') as MList[]
            if (this.mustLastIndex >= musicList.length - 1) return
            this.mustLastIndex++
            const nextMusic = musicList[this.mustLastIndex]

            await AvPlayer.stopPlay()
            this.musicTitle = nextMusic.name
            this.musicAuthor = nextMusic.author
            this.musicPicUrl = nextMusic.picUrl
            this.isPlaying = true
            if(nextMusic.url.startsWith('http')) {
              this.isDownloadMusic = false
            } else {
              this.isDownloadMusic = true
            }
            AvPlayer.playAudio(nextMusic.url)
          })
      }
      .margin({ top: 100 })
      .width('100%')
    }
    .padding(20)
    .width("100%")
    .height("100%")
  }
}