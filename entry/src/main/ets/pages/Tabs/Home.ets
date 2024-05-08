import router from '@ohos.router';
import { MockData, mockData } from "../../const/mock"
import { PlayCard } from "../../components/PlayCard"
import { MusicItem } from '../../components/MusicItem';
import { SearchBox } from '../../components/SearchBox';
import { MList } from "../../type/index"
import { showDialog } from '../../Utils/utils';

@Component
export struct Home {
  @StorageLink('token') token: string = ''
  @StorageLink('nickname') nickname: string = ''
  @StorageLink('musicList') musicList: any[] = []

  build() {
    Column() {
      Scroll() {
        Column() {
          /* 主搜索框 */
          SearchBox()
          /* 个人信息 */
          Row() {
            Flex({ direction: FlexDirection.Column }) {
              /* 个人卡片 */
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
                Image($r('app.media.defaultHeaderIcon'))
                  .width(40)
                  .height(40)
                  .borderRadius(40)
                  .margin({ right: 10 })
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                Text(this.nickname)
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                Button('登录').onClick(() => {
                  router.pushUrl({ url: 'pages/Login' })
                })
                  .visibility(this.token ? Visibility.None : Visibility.Visible)
                Text('注销>')
                  .align(Alignment.BottomEnd)
                  .fontSize(12)
                  .fontColor('black')
                  .backgroundColor('')
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                  .onClick(() => {
                    showDialog(() => {
                      this.token = ''
                      this.nickname = ''
                      this.musicList = []
                      console.log('注销成功')
                    })
                  })
              }
              .backgroundImageSize({ width: '', height: '' })

              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Column() {
                  Image($r("app.media.grey_like"))
                    .width(40)
                  Text('喜欢')
                }
                .onClick(() => {
                  router.pushUrl({ url: "pages/Mine", params: {
                    mine: 1
                  } })
                })

                Column() {
                  Image($r("app.media.download"))
                    .width(40)
                  Text('本地')
                }
                .onClick(() => {
                  router.pushUrl({ url: "pages/Mine", params: {
                    download: 1
                  } })
                })
              }.margin({ top: 15 })
            }
            .padding({ top: 15, bottom: 15, left: 15, right: 15 })
            .margin({ top: 10, bottom: 20 })
            .width('100%')
            .backgroundColor('#ccc2')
          }

          // .animation({ duration: 500 })

          /* 音乐列表 */
          Column() {
            ForEach(mockData, (item: MockData, index) => {
              MusicItem({
                list: mockData as unknown as MList[],
                item: item as unknown as MList,
                index
              })
            })
          }
        }
        .padding({ top: 10, bottom: 100, left: 10, right: 10 })
      }

      PlayCard({
        onClickEvent: () => router.pushUrl({ url: "pages/Player" }),
      })
    }
  }
}