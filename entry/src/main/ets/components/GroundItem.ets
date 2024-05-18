import { GroundItemRouterParams, GroundItemType } from '../type'

@Preview
@Component
export struct GroundItem {
  item: GroundItemType
  onClickEvent: (routerParams: GroundItemRouterParams) => void

  build() {
    Column() {
      Row() {
        Text(this.item.topicIntroduction)
          .width("100%")
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .margin({ top: 5, bottom: 5 })
      Row() {
        // 音乐封面图片
        Image(this.item.topicPic)
          .width(50)
          .height(50)

        Row() {
          // 音乐标题
          Flex({ alignItems: ItemAlign.Center }) {
            Text(this.item.topicName)
            Text('-')
            Text(this.item.musicAuthor)
              .fontSize(14)
          }
        }
        .width("100%")
        .margin({ left: 10 })

        Row() {
          Text("进入评论区>")
            .fontSize(12)
            .alignSelf(ItemAlign.End)
        }
        .position({"x":"75%","y":"50%"})
      }
      .alignItems(VerticalAlign.Center)
    }
    .margin({ bottom: 15 })
    .padding(10)
    .width("100%")
    .height(110)
    .backgroundColor("#f3f3f3")
    .borderRadius(10)
    .onClick(() => {
      this.onClickEvent({ groundId: `${this.item._id}`, groundItem: this.item })
    })
  }
}