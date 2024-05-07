import router from '@ohos.router';
import { MockData, mockData } from "../../const/mock"
import { PlayCard } from "../../components/PlayCard"
import { MusicItem } from '../../components/MusicItem';
import { SearchBox } from '../../components/SearchBox';
import { MList } from "../../type/index"

@Component
export struct Home {
  @StorageLink('token') token: string = ''
  @StorageLink('nickname') nickname: string = ''

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
              Row() {
                Image($r('app.media.defaultHeaderIcon'))
                  .width(40)
                  .height(40)
                  .borderRadius(40)
                  .margin({ right: 10 })
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                Text(this.nickname)
                Button('登录').onClick(() => {
                  router.pushUrl({ url: 'pages/Login' })
                })
                  .visibility(this.token ? Visibility.None : Visibility.Visible)
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