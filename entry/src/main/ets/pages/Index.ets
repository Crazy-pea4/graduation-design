import { PersistentKey, PersistentState } from '../Utils/AppStorage'
import { storage } from "../Utils/LocalStorage"
import { Home } from "./Tabs/Home"
import { Ground } from './Tabs/Ground'
import { Record } from './Tabs/Record'
import router from '@ohos.router'

PersistentState.setStorage(PersistentKey.token, '')
PersistentState.setStorage(PersistentKey.musicList, '[]')
PersistentState.setStorage(PersistentKey.nickname, '')

export const controller: TabsController = new TabsController()

@Entry(storage)
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0

  onPageShow() {
    const params = router.getParams() as { index: number };
    if(!params) return;
    if(params['index'] !== undefined) {
      controller.changeIndex(params['index'])
    }
  }

  @Builder
  TabBarBuilder(name: string, index: number, iconUrl?: Resource, iconUrl_select?: Resource) {
    Column() {
        Image(this.currentIndex === index ? iconUrl_select : iconUrl)
          .margin({bottom: 2})
          .width(26)
        Text(name)
          .fontSize(12)
          .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)

      // Divider()
      //   .width("40%")
      //   .strokeWidth(2)
      //   .color('#007DFF')
      //   .opacity(this.currentIndex === index ? 1 : 0)
    }
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller }) {
        TabContent() {
          // Ground();
          Home();
        }.tabBar(this.TabBarBuilder('首页', 0, $r("app.media.home"), $r("app.media.home_select")))

        TabContent() {
          Ground();
        }.tabBar(this.TabBarBuilder('广场', 1, $r("app.media.square"), $r("app.media.square_select")))

        TabContent() {
          Record();
        }.tabBar(this.TabBarBuilder('录音', 2, $r("app.media.recordIcon"), $r("app.media.recordIcon_select")))
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}