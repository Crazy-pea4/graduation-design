import router from "@ohos.router"
import { Record } from './Tabs/Mine/Record'
import { Likes } from './Tabs/Mine/Likes'
import { Downloads } from './Tabs/Mine/DownLoads'
import { MList } from '../type'
import { httpRequestGet } from '../Utils/HttpRequest'

export const controller: TabsController = new TabsController()

@Entry
@Component
struct Mine {
  @StorageLink('userId') userId: string = ''
  @State fontColor: string = '#182431'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  @State record_res: {
    author: string,
    picUrl: string,
    recordList: MList[]
  } = {} as any
  @State like_res: MList[] = [] as MList[]

  async onPageShow() {
    const params = router.getParams()

    if (params['download']) {
      controller.changeIndex(2)
      return;
    }

    const {code: record_code, data: record_data} = await httpRequestGet(`user/${this.userId}/record`, {
    }, undefined, true)
    if (record_code === 200)
      this.record_res = record_data;
    else return;
    const {code: like_code, data: like_data} = await httpRequestGet(`user/${this.userId}/music`, {}, undefined, true)
    if (like_code === 200)
      this.like_res = like_data;
    else return;

    if (params['like']) {
      controller.changeIndex(0)
    }

    if (params['record']) {
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
          Likes({ list: this.like_res })
        }.tabBar(this.TabBarBuilder('喜欢', 0))

        TabContent() {
          Record({ obj: this.record_res })
        }.tabBar(this.TabBarBuilder('录音', 1))

        TabContent() {
          Downloads()
        }.tabBar(this.TabBarBuilder('下载', 2))
      }
      .onChange(async (index: number) => {
        // switch (index) {
        //   case 0:
        //     const {code: like_code, data: like_data} = await httpRequestGet(`user/${this.userId}/music`, {
        //     }, undefined, true)
        //     if (like_code === 200)
        //       this.like_res = like_data;
        //     else return;
        //     break;
        //   case 1:
        //     const {code: record_code, data: record_data} = await httpRequestGet(`user/${this.userId}/record`, {
        //     }, undefined, true)
        //     if (record_code === 200)
        //       this.record_res = record_data;
        //     else return;
        //     break;
        //   default:
        //     break;
        // }
        this.currentIndex = index
      })
    }
  }
}