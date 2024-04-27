import router from '@ohos.router';
import { mockData } from "../const/mock"
import { PlayCard } from "../components/PlayCard"
import { AvPlayer} from "../Utils/AVPlayer"
AvPlayer.createAVPlayerInstance()

@Entry
@Component
struct Index {
  @State searchBoxHeight: string = '0%'
  @State musicTitle: string = ''
  @State musicAuthor: string = ''

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
                router.pushUrl({ url: 'pages/SearchPage' })
                console.log('123123')
              })
            //   .onTouch(() => {
            //   this.searchBoxHeight = '95%'
            // })
          }
          .padding({ left: 10, right: 10 })

          Row() {
            Column() {
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#ccc2')
          }
          .height(this.searchBoxHeight)
          .animation({ duration: 500 })
          /* 音乐列表 */
          Column() {
            ForEach(mockData, (item, index) => {
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
                this.musicTitle = item.title
                this.musicAuthor = item.author
                await AvPlayer.setAVPlayerUrl()
              })
            })
          }
          .onTouch(() => {
            this.searchBoxHeight = '0%'
          })
        }
        // .height('92%')
        .padding({ top: 10, bottom: 10 })

      }

      PlayCard({ musicTitle: $musicTitle, musicAuthor: $musicAuthor })
    }
  }
}