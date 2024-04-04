import { mockData } from "../const/mock"

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State searchBoxHeight: number = 0

  build() {
    Column() {
      /* 主搜索框 */
      Row() {
        Search({placeholder: '查找音乐'}).onTouch(() => {
          this.searchBoxHeight = 200
        })
      }
      Row() {
        Column() {
        }.width('100%').height('100%').backgroundColor('#ccc2')
      }.height(this.searchBoxHeight).animation({duration: 500})
      /* 音乐列表 */
      Column() {
        ForEach(mockData, (item, index) => {
          Row() {
            Column() {
              Row() {
                Text(item.title)
              }

              Row() {
                Text(item.author)
              }
            }
            .border({
              width: 1,
              color: 'blue'
            })
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding({
            top: (index === 0 || index === mockData.length - 1) ? 0 : 10,
            bottom: (index === 0 || index === mockData.length - 1) ? 0 : 10
          })
        })
      }.onTouch(() => {
        this.searchBoxHeight = 0
      })
    }
    .padding(10)
  }
}