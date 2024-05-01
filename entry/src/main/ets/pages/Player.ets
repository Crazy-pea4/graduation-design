@Entry
@Component
struct Player {

  build() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, direction: FlexDirection.Column }) {
      Row() {

      }
      .width(250)
      .height(250)
      .borderRadius(200)
      .backgroundColor("#aff")

      Column() {
        Slider()
          .selectedColor('black')
          .trackThickness(3)
          .onChange((progress, mode) => {
            switch (mode) {
              case SliderChangeMode.Begin:
                console.log('asdasd')
                break;

              case SliderChangeMode.End:
                break;
              default:
                break;
            }
        })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
        Text('前一首')
        Text('播放/暂停')
        Text('后一首')
      }
      .margin({top: 100})
      .width('100%')
    }
    .width("100%")
    .height("100%")
  }
}