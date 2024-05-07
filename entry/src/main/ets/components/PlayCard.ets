import { AvPlayer } from "../Utils/AVPlayer"

@Component
export struct PlayCard {
  @StorageLink('musicTitle') musicTitle: string = ''
  @StorageLink('musicAuthor') musicAuthor: string = ''
  @StorageLink('musicPicUrl') musicPicUrl: string = ''
  @StorageLink('isPlaying') isPlaying: boolean = false
  onClickEvent: () => void

  build() {
    Flex({ alignItems: ItemAlign.End }) {
      Image(this.musicPicUrl || "").width(80).height(80).backgroundColor('#aaf9')

      Row() {
        Text(`${this.musicTitle ? this.musicTitle : '暂无歌手'}-${this.musicAuthor ? this.musicAuthor : '暂无作者'}`)
      }
      .margin({ left: 10 })
      .flexGrow(1)
      .height('100%')
      .backgroundColor("#aac")

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(this.isPlaying ? $r("app.media.pause") : $r("app.media.play"))
          .width(20)
          .height(20)
      }
      .width(40)
      .height('100%')
      .backgroundColor('#aff')
      .onClick((e) => {
        if (this.isPlaying) {
          AvPlayer.pauseAudio()
          this.isPlaying = false
        } else {
          AvPlayer.playAudio()
          this.isPlaying = true
        }
      })
    }
    .position({ x: 0, y: '92%' })
    .padding({ top: 10, bottom: 10, left: 10, right: 20 })
    .height('8%')
    .width('100%')
    .backgroundColor('#ddd')
    .onClick(() => this.onClickEvent())
  }
}