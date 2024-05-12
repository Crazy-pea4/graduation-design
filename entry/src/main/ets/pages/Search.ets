import router from '@ohos.router';
import { MusicItem } from '../components/MusicItem';
import { PlayCard } from '../components/PlayCard';
import { SearchBox } from '../components/SearchBox';
import { MList } from "../type/index"
import { httpRequestGet } from '../Utils/HttpRequest';

@Entry
@Component
struct SearchPage {
  @State list: MList[] = []

  async onPageShow() {
    const params = router.getParams() || {};
    const keyword = params['searchVal'] || ''
    const {data} = await httpRequestGet('music/', { keyword })
    console.log(JSON.stringify({ data }), 'http data')
    this.list = data
  }

  build() {
    Column() {
      Scroll() {
        // Scroll 的子组件必须接一个块级组件不然会无法正常显示!!!!!
        Column() {
          /* 主搜索框 */
          SearchBox()
          Flex({direction: FlexDirection.Column}) {
            ForEach(this.list, (item: MList, index) => {
              MusicItem({
                list: this.list,
                item: item as unknown as MList,
                index
              })
            })
          }
          .padding({ top: 10, bottom: 100, left: 10, right: 10 })
        }
      }

      PlayCard({
        onClickEvent: () => router.pushUrl({ url: "pages/Player" }),
      })
    }
  }
}
