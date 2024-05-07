import router from '@ohos.router'
import { httpRequestPost } from '../Utils/HttpRequest'

@Entry
@Component
struct Login {
  @State phoneNumber: string = ''
  @State password: string = ''
  @StorageLink('token') token: string = ''
  @StorageLink('nickname') nickname: string = ''

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {

      }
      .width(150)
      .height(150)
      .backgroundColor("#ddf")
      .borderRadius(150)

      Column() {
        TextInput()
          .type(InputType.PhoneNumber)
          .margin({ bottom: 20 })
          .onChange((value) => {
            this.phoneNumber = value
          })
        TextInput()
          .type(InputType.Password)
          .onChange((value) => {
            this.password = value
          })
      }
      .width(300)
      .margin({ top: 50 })

      Flex() {
        Button('手机号登录')
          .width(270)
          .height(46)
          .margin({ bottom: 20 })
          .backgroundColor('#69e387')
          .margin({ right: 20 })
          .onClick(async () => {
            const formObj = {}
            formObj['phoneNumber'] = this.phoneNumber
            formObj['password'] = this.password
            const {code, token, data: { nickname }} = await httpRequestPost('auth/', formObj)
            if (code === 200) {
              this.token = token as string
              this.nickname = nickname
              setTimeout(() => {
                router.replaceUrl({ url: 'pages/Index' })
              }, 1000)
            }
          })
        Button('立即注册')
          .width(270)
          .height(46)
          .backgroundColor('#f7f7f7')
          .fontColor(Color.Black)
          .onClick(async () => {
            const formObj = {}
            formObj['nickname'] = this.phoneNumber
            formObj['phoneNumber'] = this.phoneNumber
            formObj['password'] = this.password
            await httpRequestPost('user/', formObj)
          })
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 10, bottom: 10, left: 20, right: 20 })
  }
}