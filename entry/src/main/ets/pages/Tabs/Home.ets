import router from '@ohos.router';
import { MockData, mockData } from "../../const/mock"
import { PlayCard } from "../../components/PlayCard"
import { AvPlayer } from "../../Utils/AVPlayer"
import { controller } from "../Index"
import { PersistentKey, PersistentState } from '../../Utils/AppStorage';

@Component
export struct Home {
  @State musicTitle: string = ''
  @State musicAuthor: string = ''
  @LocalStorageLink('isPlaying') isPlaying: boolean = false
  @StorageLink('token') token: string = ''
  @StorageLink('musicList') musicList: MockData[] = []

  build() {
    Column() {
      Scroll() {
        Column() {
          /* 主搜索框 */
          Row() {
            Search({ placeholder: '查找音乐' })
              .animation({ duration: 500 })
              .searchButton('搜索')
              .onSubmit(() => {
                router.pushUrl({ url: 'pages/Search' })
                console.log('123123')
              })
          }
          .padding({ left: 10, right: 10 })

          /* 个人信息 */
          Row() {
            Flex({ direction: FlexDirection.Column }) {
              /* 个人卡片 */
              Row() {
                Button(Boolean(this.token) ? '个人中心' : '登录').onClick(() => {
                  if (Boolean(this.token)) {
                    controller.changeIndex(1)
                  } else {
                    router.pushUrl({ url: 'pages/Login' })
                  }
                })
                Button('写入token').onClick(() => {
                  this.token = '123'
                })
                Button('注销').onClick(() => {
                  this.token = ''
                })
              }

              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Text('喜欢')
                Text('本地')
              }.margin({ top: 15 })
            }
            .padding({ top: 15, bottom: 15, left: 15, right: 15 })
            .margin({ top: 10, bottom: 20 })
            .width('100%')
            .backgroundColor('#ccc2')
          }
          .animation({ duration: 500 })

          /* 音乐列表 */
          Column() {
            ForEach(mockData, (item: MockData, index) => {
              Row() {
                Column() {
                  Row() {
                    Column() {

                    }.width(50).height('100%').backgroundColor('#aaf9')

                    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
                      Text(item.title)
                      Text('-')
                        .margin({ left: 5, right: 5 })
                      Text(item.author)
                        .fontSize(14)
                    }.margin({ left: 10 })
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
                bottom: index === mockData.length - 1 ? 0 : 10
              })
              .onClick(async () => {
                const fIndex = this.musicList.findIndex((i) => i.id === item.id)
                if (fIndex !== -1) {
                  // 如果 当前点击的音乐 已经在 播放列表里面
                  this.musicList.splice(fIndex, 1)
                  this.musicList.push(item)
                }
                this.musicList.push(item)
                PersistentState.getStorage(PersistentKey.musicList)
                this.musicTitle = item.title
                this.musicAuthor = item.author
                this.isPlaying = true
                await AvPlayer.stopPlay()
                AvPlayer.playAudio(item.url)
              })
            })
          }
        }
        .padding({ top: 10, bottom: 100, left: 10, right: 10 })
      }

      PlayCard({
        musicTitle: $musicTitle,
        musicAuthor: $musicAuthor,
        onClickEvent: () => router.pushUrl({ url: "pages/Player", params: {
          title: this.musicTitle,
          author: this.musicAuthor
        } }),
      })
    }
  }
}