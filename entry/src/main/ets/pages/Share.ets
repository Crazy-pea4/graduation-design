import { httpRequestPost } from '../Utils/HttpRequest'
import router from '@ohos.router'

@Entry
@Component
struct Share {
  @State textAreaVal: string = ''
  @StorageLink('musicId') musicId: string = ''
  @StorageLink('musicTitle') musicTitle: string = ''
  @StorageLink('musicAuthor') musicAuthor: string = ''
  @StorageLink('musicPicUrl') musicPicUrl: string = ''

  @Styles
  onPress() {
    .backgroundColor('#ffffff')
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('取消')
        Text('发表')
          .width(60)
          .height(40)
          .borderRadius(10)
          .textAlign(TextAlign.Center)
          .fontColor('#fff')
          .backgroundColor($r("app.color.main_color"))
          .onClick(async () => {
            const params = {
              musicId: this.musicId,
              topicName: this.musicTitle,
              topicPic: this.musicPicUrl,
              topicIntroduction: this.textAreaVal
            }
            const res = await httpRequestPost("topic/", params, true, true)
            if (res.code === 200) {
              router.replaceUrl({ url: "pages/Index", params: { index: 1 } })
            }
            console.log(`${res}`)
          })
      }

      Column() {
        Row() {
          TextArea({ placeholder: '这一刻的想法...' })
            .margin({ top: 25, bottom: 25 })
            .padding(0)
            .backgroundColor("#ffffff")
            .stateStyles({ pressed: this.onPress })
            .height(60)
            .onChange((value) => {
              this.textAreaVal = value
            })
        }

        Row() {
          Image(this.musicPicUrl || "")
            .width(70)
            .height(70)
            .backgroundColor("#ddf")

          // 音乐名称和作者
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
            Row() {
              Text(this.musicTitle + '-' + this.musicAuthor || "暂无数据")
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontSize(14)
            }
            .width("100%")

            Row() {
              Text(this.musicAuthor || "暂无作者")
                .fontSize(14)
                .fontColor("#fdfdfd")
            }
          }
          .width("166vp")
          .height(70)
          .margin({ left: 10 })
        }
        .width("85%")
        .backgroundColor("#dedede")

        Column() {
          Row() {
            Text('id: ')
              .fontSize(12)
              .fontColor('#ddd')
            Text(this.musicId || 'f689sdk98fs08saj')
              .fontSize(12)
              .fontColor('#ddd')
          }
        }
        .margin({ top: 20 })
        .width("100%")
        .alignItems(HorizontalAlign.End)
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16 })
    }
    .padding(20)
    .width("100%")
    .height("100%")
  }
}