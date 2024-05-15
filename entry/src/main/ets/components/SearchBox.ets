import router from '@ohos.router'

@Component
export struct SearchBox {
  searchBoxPlaceholder: string

  build() {
    Row() {
      Search({ placeholder: this.searchBoxPlaceholder || '查找音乐' })
        .animation({ duration: 500 })
        .searchButton('搜索')
        .onSubmit((value) => {
          router.pushUrl({ url: 'pages/Search', params: { searchVal: value } })
        })
    }
    .padding({ left: 10, right: 10 })
  }
}