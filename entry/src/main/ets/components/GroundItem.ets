interface RouterParams {
  groundUrl: string;
}

@Component
export struct GroundItem {
  @Prop index: number
  @State isLike: boolean = false
  onClickEvent: (routerParams: RouterParams) => void

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween }) {
      // 音乐封面图片
      Column() {
        Image('')
          .width("100%")
          .height("100%")
          .backgroundColor("#ddf")
      }
      .width(80)
      .height(80)
      .onClick(() => {
        this.onClickEvent({ groundUrl: `${this.index}` })
      })

      Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween}) {
        // 音乐标题
        Flex({alignItems: ItemAlign.Center}) {
          Text('音乐标题')
          Text('-')
          Text('音乐作者')
            .fontSize(14)
        }

        Flex() {
          Text('你知道巴拉巴拉123123缴纳罚款你发觉能否阿三大苏打实打实啊实打实的啊实打实大苏打')
            .maxLines(2)
            .textOverflow({overflow: TextOverflow.Ellipsis})
        }
        .margin({top: 10})

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
      .height("100%")
      .margin({left: 10})
      .onClick(() => {
        this.onClickEvent({ groundUrl: `${this.index}` })
      })
    }
    .margin({ bottom: 15 })
    .padding(10)
    .width("100%")
    .height(110)
    .backgroundColor("#f3f3f3")
    .borderRadius(10)
  }
}