import promptAction from '@ohos.promptAction'
import { ServerData } from './HttpRequest'

/********************************/
/* 单位: 毫秒 */
export async function sleep(time: number = 100) {
  await new Promise((res) => setTimeout(() => res(1), time))
}
/********************************/


/********************************/
export function msTransform(ms: number) {
  const min = Math.floor((ms / 1000) / 60)
  const sec = Math.floor((ms / 1000) % 60)

  let strMin: string = `${min}`
  let strSec: string = `${sec}`
  if(min < 10) {
    strMin = '0' + min
  }

  if(sec < 10) {
    strSec = '0' + sec
  }

  return `${strMin}:${strSec}`
}
/********************************/

/********************************/
// NOTE: A value less than 1500 is automatically changed to 1500. The maximum value is 10000ms.
export function showToast(message: string, duration = 1500) {
  promptAction.showToast({ message, duration })
}
/********************************/

export function showDialog(cb: () => void) {
  promptAction.showDialog({
    title: '确认注销吗？',
    message: '',
    buttons: [
      {
        text: '注销',
        color: '#000000',
      },
      {
        text: '取消',
        color: '#000000',
      }
    ],
  })
    .then(data => {
      if(data.index === 0) {
        cb()
      }
      console.info('showDialog success, click button: ' + data.index);
    })
    .catch(err => {
      console.info('showDialog error: ' + err);
    })
}