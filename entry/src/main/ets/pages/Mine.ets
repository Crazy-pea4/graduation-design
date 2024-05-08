import router from "@ohos.router"

export const controller: TabsController = new TabsController()

@Entry
@Component
struct Mine {
  @StorageLink('token') token: string = ''
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0

  onPageShow() {
    const params = router.getParams()
    if(params['mine']) {
      controller.changeIndex(0)
    }
    if(params['download']) {
      controller.changeIndex(1)
    }
  }

  @Builder
  TabBarBuilder(name: string, index: number) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
      Divider()
        .width("20%")
        .strokeWidth(2)
        .color('#007DFF')
        .opacity(this.currentIndex === index ? 1 : 0)
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, controller }) {
        TabContent() {
          Text('喜欢')
        }.tabBar(this.TabBarBuilder('喜欢', 0))

        TabContent() {
          Text('下载')
        }.tabBar(this.TabBarBuilder('下载', 1))
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}