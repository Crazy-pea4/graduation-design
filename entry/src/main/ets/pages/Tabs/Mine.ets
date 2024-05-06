import router from "@ohos.router"

@Component
export struct Mine {
  @StorageLink('token') token: string = ''

  // aboutToAppear() {
  //   console.log(this.token, 'this.token')
  //   if(!this.token) {
  //     router.replaceUrl({url: "pages/Login"})
  //   }
  // }

  build() {
    Column() {
      Image($r('app.media.defaultHeaderIcon'))
        .width(100)
        .height(100)
        .borderRadius(40)
        .margin({ right: 10 })
    }.onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      // 当currentRatio === 1 的时候就是进入 ‘我的’ tab页时
      // if (currentRatio && !this.token) {
      //   router.replaceUrl({ url: "pages/Login" })
      // }
    })
  }
}