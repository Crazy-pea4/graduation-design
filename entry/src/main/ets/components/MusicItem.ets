import fs from '@ohos.file.fs';
import { AppState, PersistentKey } from '../Utils/AppStorage'
import { AvPlayer, PlayAudioFrom } from '../Utils/AVPlayer'
import { MList } from "../type/index"
import { showDialog } from '../Utils/utils'

@Preview
@Component
export struct MusicItem {
  item: MList
  list: MList[]
  index: number
  //
  showDeleteButton: boolean = false
  cb: () => any = () => {}
  //
  @StorageLink('userId') userId: string = ''
  @StorageLink('token') token: string = ''
  @StorageLink('nickname') nickname: string = ''

  build() {
    Row() {
      Column() {
        Row() {
          Image(this.item.picUrl || '')
            .width(50)
            .height('100%')

          // 音乐名称和作者
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
            Text(this.item.name || 'this.item.name')
            Text('-')
              .margin({ left: 5, right: 5 })
            Text(this.item.author || 'this.item.author')
              .fontSize(14)
          }
          .margin({ left: 10 })

          Image($r("app.media.delete"))
            .position({x: '93%', y: 14})
            .width(20)
            .visibility(this.showDeleteButton ? Visibility.Visible : Visibility.None)
            .onClick(() => {
              showDialog.deleteDownLoadMusic('确定删除吗', '删除', '取消', () => {
                fs.unlinkSync(this.item.url)
                this.cb()
              })
            })
        }
      }
      .border({
        width: 1,
        color: '#aaf'
      })
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10, right: 10 })
    }
    .width('100%')
    .height(50)
    .margin({
      bottom: this.index === this.list.length - 1 ? 0 : 10
    })
    .onClick(async () => {
      const musicList = JSON.parse(AppState.getState(PersistentKey.musicList))
      const fIndex = musicList.findIndex((i) => {
        if (i._id === this.item._id) {
          return true
        }
      })
      if (fIndex !== -1) {
        // 如果 当前点击的音乐 已经在 播放列表里面
        musicList.splice(fIndex, 1)
      }
      musicList.push(this.item)
      AppState.setState(PersistentKey.musicList, JSON.stringify(musicList))

      AppState.setState('musicTitle', this.item.name)
      AppState.setState('musicAuthor', this.item.author || this.nickname)
      AppState.setState('musicId', this.item._id)
      AppState.setState('isPlaying', true)
      AppState.setState('musicPicUrl', this.item.picUrl || '')
      AppState.setState('musicUrl', this.item.url)
      if (this.item.likesList) {
        const isLiked = this.item.likesList.some((item) => item === this.userId)
        AppState.setState('isLiked', isLiked)
      }
      await AvPlayer.stopPlay()
      AvPlayer.playAudio(this.item.url)
    })
  }
}