import router from '@ohos.router';
import { AppState, StateKey } from '../Utils/AppStorage';
import { AvPlayer } from '../Utils/AVPlayer';
import { storage } from '../Utils/LocalStorage';
import { msTransform } from '../Utils/TimeTransform';

@Entry(storage)
@Component
struct Player {
  @State angleA: number = 0
  @State title: string = ''
  @State author: string = ''
  @LocalStorageLink('isPlaying') isPlaying: boolean = false
  @State duration: string = '00:00'

  onPageShow() {
    const params = router.getParams() || {};
    this.title = params['title'] || '暂无歌曲'
    this.author = params['author'] || '暂无作者'

    /* 音频总时长转换 */
    const ms = AppState.getState<number>(StateKey.musicDuration) || 0
    const res = msTransform(ms)
    this.duration = res

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
        Column() {
          Text('123123')
        }
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
      .backgroundColor("#aadf")

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Flex({direction: FlexDirection.Column}) {
          Text(this.title)
            .margin({ bottom: 8 })
            .fontWeight(700)
          Text(this.author)
            .fontSize(15)
        }
        Text(this.duration)
      }
      .margin({ top: 40 })
      .width('100%')
      .height(50)
      .backgroundColor("#ffdd")

      Column() {
        Slider()
          .selectedColor('black')
          .trackThickness(3)
          .onChange((progress, mode) => {
            switch (mode) {
              case SliderChangeMode.Begin:
                console.log('asdasd')
                break;

              case SliderChangeMode.End:
                break;
              default:
                break;
            }
          })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Text('前一首')
        Text(this.isPlaying ? '暂停' : '播放')
          .onClick(() => {
            if (this.isPlaying) {
              AvPlayer.pauseAudio()
              this.isPlaying = false
            } else {
              AvPlayer.playAudio()
              this.isPlaying = true
            }
          })
        Text('后一首')
      }
      .margin({ top: 100 })
      .width('100%')
    }
    .padding(20)
    .width("100%")
    .height("100%")
  }
}