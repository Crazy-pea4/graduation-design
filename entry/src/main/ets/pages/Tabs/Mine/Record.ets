import { MusicItem } from '../../../components/MusicItem'
import { PlayCard } from '../../../components/PlayCard'
import { MList } from '../../../type'
import { httpRequestGet } from '../../../Utils/HttpRequest'

@Component
export struct Record {
  @StorageLink('userId') userId: string = ''
  @Prop obj: {
    author: string,
    picUrl: string,
    recordList: MList[]
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          ForEach(this.obj.recordList, (item, index) => {
            MusicItem({
              item: { author: this.obj.author, picUrl: this.obj.picUrl, ...item } as MList,
              list: this.obj.recordList as MList[],
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