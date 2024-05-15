import { GroundItem } from '../../components/GroundItem'
import { SearchBox } from '../../components/SearchBox'
import router from '@ohos.router'

@Component
export struct Ground {
  @State testArr: number[] = new Array(10).fill(1)

  build() {
    Column() {
      Scroll() {
        Column() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
            SearchBox()
            Flex({ direction: FlexDirection.Column }) {
              ForEach(this.testArr, (_, index) => {
                GroundItem({
                  index: index as number,
                  onClickEvent: (routerParams) => {
                    const {groundUrl} = routerParams
                    router.pushUrl({ url: "pages/GroundDetail", params: { groundUrl } })
                  }
                })
              })
            }
            .padding({ top: 15, bottom: 15, left: 15, right: 15 })
          }
        }
      }
    }
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }
}