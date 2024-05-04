import { PersistentKey, PersistentState } from '../Utils/AppStorage'
import { storage } from "../Utils/LocalStorage"
import { Ground } from './Tabs/Ground'

import { Home } from "./Tabs/Home"
import { Mine } from "./Tabs/Mine"

export const controller: TabsController = new TabsController()

PersistentState.setStorage(PersistentKey.token, '')
PersistentState.setStorage(PersistentKey.musicList, [])

@Entry(storage)
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0

  @Builder TabBarBuilder(name: string, index: number) {
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
      Tabs({barPosition: BarPosition.End, controller}) {
        TabContent() {
          Home();
        }.tabBar(this.TabBarBuilder('首页', 0))

        TabContent() {
          Ground();
        }.tabBar(this.TabBarBuilder('广场', 1))

        TabContent() {
          Mine();
        }.tabBar(this.TabBarBuilder('我的', 2))
      }
      .onChange((index: number) => {
          this.currentIndex = index
      })
    }
  }
}