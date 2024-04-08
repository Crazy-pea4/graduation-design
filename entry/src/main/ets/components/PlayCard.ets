@Component
export struct PlayCard {
  @Link musicTitle: string
  @Link musicAuthor: string

  build() {
    Flex({alignItems: ItemAlign.End}) {
      Image('1').width(80).height(80).backgroundColor('#aaf9')

      Row() {
        Text(`${this.musicTitle ? this.musicTitle + '-' : ''}${this.musicAuthor ? this.musicAuthor : ''}`)
      }
      .margin({left: 10})
      .flexGrow(1)
      .height('100%')
      .backgroundColor("#aac")

      Row() {
        Text('播')
      }.height('100%')
    }
    .position({x: 0, y: '92%'})
    .padding(10)
    .height('8%')
    .width('100%')
    .backgroundColor('#ddd')
  }
}