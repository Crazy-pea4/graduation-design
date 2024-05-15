import router from '@ohos.router'
import { GroundItemRouterParams } from '../type'


@Entry
@Component
struct GroundDetail {
  @State test: string = ''

  onPageShow() {
    const {groundUrl} = router.getParams() as GroundItemRouterParams
    console.log(groundUrl, 123123)
    this.test = groundUrl
  }

  build() {
    Text(this.test)
  }
}