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
    const keyword = params['searchVal']
    const {data} = await httpRequestGet('music/', { keyword })
    this.list = data
  }

  build() {
    Column() {
      Scroll() {
        /* 主搜索框 */
        SearchBox()
        Flex({ direction: FlexDirection.Column }) {
          ForEach(this.list, (item: MList, index) => {
            MusicItem({
              list: this.list,
              item,
              index
            })
          })
        }.padding({ top: 10, bottom: 100, left: 10, right: 10 })
      }

      PlayCard({
        onClickEvent: () => router.pushUrl({ url: "pages/Player" }),
      })
    }
  }
}
