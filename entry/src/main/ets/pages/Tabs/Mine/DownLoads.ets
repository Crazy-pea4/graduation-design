import fs from '@ohos.file.fs';
import { MusicItem } from '../../../components/MusicItem';
import { MList } from '../../../type';
import { PlayAudioFrom } from '../../../Utils/AVPlayer';
import { toChineseWords } from '../../../Utils/utils';
import router from '@ohos.router';

interface DownloadList {
  name: string,
  url: string
}

@Component
export struct Downloads {
  @State downloadList: DownloadList[] = []

  aboutToAppear() {
    const fileList = fs.listFileSync(getContext(this).tempDir)
    if (!fileList.length) return;

    const downloadList = fileList.map((file) => {
      const unicode = file.split('_')[0]
      const ChineseWords = toChineseWords(unicode)
      const name = ChineseWords.split('_')[0]
      const author = ChineseWords.split('_')[1]
      console.log(`${ChineseWords}`, file, name, author, 'fileList123')

      return { name, author, picUrl: $r("app.media.download_cover"), url: `${getContext(this).tempDir}/${file}` }
    })

    this.downloadList = downloadList
  }

  build() {
    Scroll() {
      Column() {
        ForEach(this.downloadList, (file: DownloadList, index) => {
          MusicItem({
            item: file as MList,
            list: this.downloadList as MList[],
            index: index as number,
            showDeleteButton: true,
            cb: () => {
              router.replaceUrl({ url: 'pages/Mine', params: { download: 1 } })
            }
          })
        })
      }
      .height("100%")
    }

    // Text('点击查看文件列表')
    //   .onClick(() => {
    //     const fileList = fs.listFileSync(getContext(this).tempDir)
    //     fileList.forEach((file) => {
    //       const unicode = file.split('_')[0]
    //       const ChineseWords = toChineseWords(unicode)
    //       console.log(`${ChineseWords}`, file, 'fileList123')
    //     })
    //   })
  }
}