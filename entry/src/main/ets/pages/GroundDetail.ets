import router from '@ohos.router'
import { GroundDetailType, GroundItemRouterParams, GroundItemType } from '../type'
import { httpRequestGet, httpRequestPost } from '../Utils/HttpRequest'


@Entry
@Component
struct GroundDetail {
  @State list: GroundDetailType[] = []
  @State groundInfo: GroundItemType = {} as GroundItemType
  @State inputValue: string = ''

  async onPageShow() {
    const { groundId, groundItem } = router.getParams() as GroundItemRouterParams
    const { data } = await httpRequestGet(`topic/${groundId}/questions`)
    this.list = data
    this.groundInfo = groundItem
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Column() {
            Text(this.groundInfo.topicName || '123123')
            Image(this.groundInfo.topicPic)
              .margin(10)
              .width(100)
              .height(100)
            Text(this.groundInfo.musicAuthor || '123123/asdad')
            Text('id: ' + this.groundInfo._id)
              .width("100%")
              .textAlign(TextAlign.End)
              .fontSize(12)
              .fontColor("#ddd")
              .margin({top: 5})
          }
          .width('100%')

          Text('评论区：')
            .margin({top: 8, bottom: 15})
            .width("100%")

          ForEach(this.list, (item: GroundDetailType) => {
            Column() {
              // 问题项
              Column() {
                Row() {
                  Image(item.questioner.avatarUrl)
                    .width(50)
                    .height(50)
                    .borderRadius(100)
                    .backgroundColor("#ddd")
                    .margin({ right: 10 })

                  Text(item.questioner.nickname)
                    .flexGrow(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width("100%")

                Flex({ direction: FlexDirection.Column }) {
                  Text(item.title)
                    .width("100%")
                    .padding({ left: 60 })
                }
                .flexGrow(1)
              }
              .alignItems(HorizontalAlign.Start)
              .padding(10)
              .width('100%')
              .borderRadius(6)

              Divider()
                .color('#ddf')
            }
            .margin({ bottom: 10 })
            .width("100%")
          })
        }
      }
      .padding(15)

      Row() {
        TextInput({placeholder: '友善的发言', text: this.inputValue})
          .placeholderFont({size: 14})
          .fontSize(14)
          .width("80%")
          .flexGrow(1)
          .onChange((value) => {
            this.inputValue = value
          })
        Text('发表')
          .fontSize(14)
          .margin({left: "5%"})
          .fontColor("#fff")
          .backgroundColor($r("app.color.main_color"))
          .textAlign(TextAlign.Center)
          .width("15%")
          .height(30)
          .borderRadius(10)
          .onClick(async () => {
            const params = {
              title: this.inputValue,
              topics: [this.groundInfo._id]
            }
            const { code } = await httpRequestPost('question', params, true)
            if(code === 200) {
              this.inputValue = ''
              const { data } = await httpRequestGet(`topic/${this.groundInfo._id}/questions`)
              this.list = data
            }
          })
      }
      .width("100%")
      .position({ x: 0, y: '92%' })
      .padding(15)
      .backgroundColor("#dddd")
    }
  }
}