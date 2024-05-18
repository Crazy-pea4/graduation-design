import { MusicItem } from '../../../components/MusicItem'
import { PlayCard } from '../../../components/PlayCard'
import { MList } from '../../../type'
import { httpRequestGet } from '../../../Utils/HttpRequest'

@Component
export struct Likes {
  @StorageLink('userId') userId: string = ''
  @Prop list: MList[]

  build() {
    Column() {
      Scroll() {
        Column() {
          ForEach(this.list, (item, index) => {
            MusicItem({
              item: item as MList,
              list: this.list as MList[],
              index: index as number
            })
          })
        }
        .height("100%")
        .alignItems(HorizontalAlign.Start)
        .padding(15)
      }

      PlayCard({
        onClickEvent: () => {
        }
      })
    }
  }
}