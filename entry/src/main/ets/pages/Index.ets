import { PersistentKey, PersistentState } from '../Utils/AppStorage'
import { storage } from "../Utils/LocalStorage"
import { Home } from "./Tabs/Home"
import { Ground } from './Tabs/Ground'
import { Record } from './Tabs/Record'

PersistentState.setStorage(PersistentKey.token, '')
PersistentState.setStorage(PersistentKey.musicList, '[]')
PersistentState.setStorage(PersistentKey.nickname, '')

@Entry(storage)
@Component
struct Index {
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0

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
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          // Ground();
          Home();
        }.tabBar(this.TabBarBuilder('首页', 0))

        TabContent() {
          Ground();
        }.tabBar(this.TabBarBuilder('广场', 1))

        TabContent() {
          Record();
        }.tabBar(this.TabBarBuilder('录音', 2))
      }
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
  }
}