import Prompt from '@system.prompt'
import router from '@ohos.router'
import { httpRequestPost } from '../Utils/HttpRequest'

@Entry
@Component
struct Login {
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {

      }
      .width(150)
      .height(150)
      .backgroundColor("#ddf")
      .borderRadius(150)

      Column() {
        Button('手机号登录')
          .width(270)
          .height(46)
          .margin({ bottom: 20 })
          .backgroundColor('#69e387')
          .onClick(() => {
            Prompt.showToast({ message: "登录成功", duration: 1 })
            setTimeout(() => {
              router.replaceUrl({ url: 'pages/Index' })
            }, 1000)
          })
        Button('立即注册')
          .width(270)
          .height(46)
          .backgroundColor('#f7f7f7')
          .fontColor(Color.Black)
          .onClick(() => {
            httpRequestPost('user/', {})
          })
      }
      .margin({ top: 150 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10, bottom: 10, left: 10, right: 10 })
  }
}