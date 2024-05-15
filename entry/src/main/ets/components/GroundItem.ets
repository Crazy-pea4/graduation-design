import { GroundItemType } from '../type'
interface RouterParams {
  groundUrl: string;
}

@Component
export struct GroundItem {
  item: GroundItemType
  @Prop index: number
  @State isLike: boolean = false
  onClickEvent: (routerParams: RouterParams) => void

  build() {
    Column() {
      Row() {
        Text(this.item.topicIntroduction)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .onClick(() => {
            this.onClickEvent({ groundUrl: `${this.index}` })
          })
      }
      .margin({ top: 5, bottom: 5 })
      Row() {
        // 音乐封面图片
        Image(this.item.topicPic)
          .width(50)
          .height(50)
          .backgroundColor("#ddf")
          .onClick(() => {
            this.onClickEvent({ groundUrl: `${this.index}` })
          })

        Row() {
          // 音乐标题
          Flex({ alignItems: ItemAlign.Center }) {
            Text(this.item.topicName)
            Text('-')
            Text(this.item.musicAuthor)
              .fontSize(14)
          }
        }
        .margin({ left: 10 })
        .onClick(() => {
          this.onClickEvent({ groundUrl: `${this.index}` })
        })

        Row() {
          // 喜欢
          Image(this.isLike ? $r("app.media.red_like") : $r("app.media.like"))
            .width(20)
            .height(20)
            .alignSelf(ItemAlign.End)
            .onClick(() => {
              // 后台接口
              this.isLike = !this.isLike
            })
        }
        .position({"x":"90.00%","y":"26%"})
      }
      .alignItems(VerticalAlign.Center)
    }
    .margin({ bottom: 15 })
    .padding(10)
    .width("100%")
    .height(120)
    .backgroundColor("#f3f3f3")
    .borderRadius(10)
  }
}