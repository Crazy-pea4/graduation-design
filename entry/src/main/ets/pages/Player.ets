import { MockData } from '../const/mock';
import { AppState, PersistentKey, StateKey } from '../Utils/AppStorage';
import { AvPlayer } from '../Utils/AVPlayer';
import { storage } from '../Utils/LocalStorage';
import { msTransform } from '../Utils/utils';
import { MList } from "../type/index"

@Entry(storage)
@Component
struct Player {
  @State angleA: number = 0
  @State isSliderDrag: boolean = false
  @State dragCurrentPercent: number = 0
  @StorageLink('musicTitle') musicTitle: string = ''
  @StorageLink('musicAuthor') musicAuthor: string = ''
  @StorageLink('musicPicUrl') musicPicUrl: string = ''
  @StorageLink('isPlaying') isPlaying: boolean = false
  @StorageLink('musicDuration') musicDuration: string = '00:00'
  @StorageLink('duration') duration: number = 0
  @StorageLink('musicTime') musicTime: number = 0
  // 初始时代表musicList的倒数第1位
  @State mustLastIndex: number = JSON.parse(AppState.getState(PersistentKey.musicList)).length - 1

  onPageShow() {
    // const ms = AppState.getState<number>(StateKey.musicDuration) || 0
    // const res = msTransform(ms)
    // this.duration = res

    if (this.isPlaying) {
      animateTo({
        duration: 10000,
        curve: Curve.Linear,
        iterations: -1, // 设置-1表示动画无限循环
      }, () => {
        this.angleA = 360
      })
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, direction: FlexDirection.Column }) {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.musicPicUrl || "")
          .width(250)
          .height(250)
          .borderRadius(200)
          .backgroundColor("#aff")
          .animation({ duration: 2000 })
          .rotate({
            angle: this.angleA
          })
      }
      .width('100%')
      .height('330vp')
      .backgroundColor("#aadff1f1")

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Flex({ direction: FlexDirection.Column }) {
          Text(this.musicTitle || '暂无标题')
            .margin({ bottom: 8 })
            .fontWeight(700)
          Text(this.musicAuthor || '暂无作者')
            .fontSize(15)
        }

        Text(this.musicDuration)
      }
      .margin({ top: 40 })
      .width('100%')
      .height(50)
      .backgroundColor("#ffdd")

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