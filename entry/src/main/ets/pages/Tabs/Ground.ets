import { GroundItem } from '../../components/GroundItem'
import { SearchBox } from '../../components/SearchBox'
import { httpRequestGet } from '../../Utils/HttpRequest';
import router from '@ohos.router'
import { GroundItemType } from '../../type';

@Component
export struct Ground {
  @State reqData: any[] = []

  async aboutToAppear() {
    const { data } = await httpRequestGet('topic/', { keyword: '' }) as { data: GroundItemType[] }
    this.reqData = data
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
            SearchBox({
              searchBoxPlaceholder: '查找话题'
            })
            Flex({ direction: FlexDirection.Column }) {
              ForEach(this.reqData, (item, index) => {
                GroundItem({
                  item,
                  onClickEvent: (routerParams) => {
                    const { groundId, groundItem } = routerParams
                    router.pushUrl({ url: "pages/GroundDetail", params: { groundId, groundItem } })
                  }
                })
              })
            }
            .padding({ top: 15, bottom: 15, left: 15, right: 15 })
          }
        }
      }
    }
    .padding({ top: 10 })
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}