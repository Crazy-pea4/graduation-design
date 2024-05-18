import fs from '@ohos.file.fs';
import router from '@ohos.router';
import { MockData, mockData } from "../../const/mock"
import { PlayCard } from "../../components/PlayCard"
import { MusicItem } from '../../components/MusicItem';
import { SearchBox } from '../../components/SearchBox';
import { MList } from "../../type/index"
import { showDialog } from '../../Utils/utils';
import { httpRequestGet, httpRequestPost } from '../../Utils/HttpRequest';
import picker from '@ohos.file.picker';
import request from '@ohos.request';
import common from '@ohos.app.ability.common';
import { BASE_URL } from '../../const';

let photoPicker = new picker.PhotoViewPicker();

@Component
export struct Home {
  @StorageLink('token') token: string = ''
  @StorageLink('nickname') nickname: string = ''
  @StorageLink('musicList') musicList: string = '[]'
  @StorageLink('userId') userId: string = ''
  @StorageLink('avatarUrl') avatarUrl: string = ''
  @State avatarTempUrl: string = ''
  @State reqData: MList[] = []

  async aboutToAppear() {
    const { data } = await httpRequestGet('music/', { keyword: '' }) as { data: MList[] }
    this.reqData = [...data.slice(0, 7)];
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          /* 主搜索框 */
          SearchBox()
          /* 个人信息 */
          Row() {
            Flex({ direction: FlexDirection.Column }) {
              /* 个人卡片 */
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
                Image(this.avatarTempUrl || this.avatarUrl || $r('app.media.defaultHeaderIcon'))
                  .width(60)
                  .height(60)
                  .borderRadius(40)
                  .margin({ right: 10 })
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                  .onClick(async () => {
                    const { photoUris } = await photoPicker.select({
                      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE,
                      maxSelectNumber: 1
                    })
                    const photoUrl = photoUris[0]
                    this.avatarTempUrl = photoUrl
                    console.log(photoUrl, 'photoUrl')
                    // 将本地应用文件上传至网络服务器
                    try {
                      const context = getContext(this) as common.UIAbilityContext;
                      // 获取应用文件路径
                      let cacheDir = context.cacheDir;
                      const file = fs.openSync(photoUrl, fs.OpenMode.READ_ONLY)
                      let fileFD = file.fd
                      await fs.copyFile(fileFD, cacheDir + '/avatar.jpg')

                      // 上传任务配置项
                      let uploadConfig = {
                        url: `${BASE_URL}upload/${this.userId}`,
                        header: { key1: 'Content-Type', key2: 'multipart/form-data' },
                        method: 'POST',
                        files: [
                          { filename: 'avatar.jpg', name: 'file', uri: 'internal://cache/avatar.jpg', type: 'jpg' }
                        // { filename: 'test.txt', name: 'file', uri: 'internal://cache/test.txt', type: 'txt' }
                        ],
                        data: []
                      }
                      request.uploadFile(context, uploadConfig)
                        .then((uploadTask) => {
                          uploadTask.on('complete', (taskStates) => {
                            for (let i = 0; i < taskStates.length; i++) {
                              console.info(`upload complete taskState: ${JSON.stringify(taskStates[i])}`);
                            }
                          });
                        })
                        .catch((err) => {
                          console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
                        })
                    } catch (err) {
                      console.error(`Invoke uploadFile failed, code is ${err.code}, message is ${err.message}`);
                    }
                  })

                Text(this.nickname)
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                Button('登录').onClick(() => {
                  router.pushUrl({ url: 'pages/Login' })
                })
                  .visibility(this.token ? Visibility.None : Visibility.Visible)
                Text('注销>')
                  .align(Alignment.BottomEnd)
                  .fontSize(12)
                  .fontColor('black')
                  .backgroundColor('')
                  .visibility(this.token ? Visibility.Visible : Visibility.None)
                  .onClick(() => {
                    showDialog.logOff('确定注销吗', '注销', '取消', () => {
                      this.token = ''
                      this.nickname = ''
                      this.musicList = '[]'
                      this.userId = ''
                    })
                  })
              }
              .backgroundImageSize({ width: '', height: '' })

              Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Column() {
                  Image($r("app.media.grey_like"))
                    .width(40)
                  Text('喜欢')
                }
                .onClick(async () => {
                  router.pushUrl({ url: "pages/Mine", params: {
                    like: 1
                  } })
                })

                Column() {
                  Image($r("app.media.record_mine"))
                    .width(40)
                  Text('录音')
                }
                .onClick(() => {
                  router.pushUrl({ url: "pages/Mine", params: {
                    record: 1
                  } })
                })

                Column() {
                  Image($r("app.media.download"))
                    .width(40)
                  Text('本地')
                }
                .onClick(() => {
                  router.pushUrl({ url: "pages/Mine", params: {
                    download: 1
                  } })
                })
              }.margin({ top: 15 })
            }
            .padding({ top: 15, bottom: 15, left: 15, right: 15 })
            .margin({ top: 10, bottom: 20 })
            .width('100%')
            .backgroundColor('#f1f1f1')
          }

          // .animation({ duration: 500 })

          /* 音乐列表 */
          Column() {
            ForEach(this.reqData, (item: MockData, index) => {
              MusicItem({
                list: this.reqData as unknown as MList[],
                item: item as unknown as MList,
                index: index as number
              })
            })
          }
        }
        .padding({ top: 10, bottom: 100, left: 10, right: 10 })
      }

      PlayCard({
        onClickEvent: () => router.pushUrl({ url: "pages/Player" }),
      })
    }
    .height("100%")
    .alignItems(HorizontalAlign.Start)
  }
}