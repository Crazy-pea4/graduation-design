import router from '@ohos.router'

@Component
export struct SearchBox {
  build() {
    Row() {
      Search({ placeholder: '查找音乐' })
        .animation({ duration: 500 })
        .searchButton('搜索')
        .onSubmit((value) => {
          router.pushUrl({ url: 'pages/Search', params: { searchVal: value } })
          console.log('123123')
        })
    }
    .padding({ left: 10, right: 10 })
  }
}