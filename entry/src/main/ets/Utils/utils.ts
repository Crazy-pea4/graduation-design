import promptAction from '@ohos.promptAction'
import { ServerData } from './HttpRequest'

/********************************/
/* 单位: 毫秒 */
export async function sleep(time: number = 600) {
  await new Promise((res) => setTimeout(() => res(1), time))
}
/********************************/


/********************************/
export function msTransform(ms: number) {
  const min = Math.floor((ms / 1000) / 60)
  const sec = Math.floor((ms / 1000) % 60)

  let strMin: string = `${min}`
  let strSec: string = `${sec}`
  if (min < 10) {
    strMin = '0' + min
  }

  if (sec < 10) {
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
async function genDialogText(title: string, okText: string, cancelText: string) {
  const data = await promptAction.showDialog({
    title,
    message: '',
    buttons: [
      {
        text: okText,
        color: '#000000',
      },
      {
        text: cancelText,
        color: '#000000',
      }
    ],
  })

  return data
}
export const showDialog = {
  logOff: async function (title: string, okText: string, cancelText: string, cb: () => void) {
    try {
      const data = await genDialogText(title, okText, cancelText)
      if (data.index === 0) {
        cb()
      }
      console.info('showDialog success, click button: ' + data.index);
    } catch (err) {
      console.info('showDialog error: ' + err);
    }
  },
  deleteDownLoadMusic: async function (title: string, okText: string, cancelText: string, cb: () => void) {
    try {
      const data = await genDialogText(title, okText, cancelText)
      if (data.index === 0) {
        cb()
      }
      console.info('showDialog success, click button: ' + data.index);
      return
    } catch (err) {
      console.info('showDialog error: ' + err);
    }
  }
}

export function toUnicodeFun(data) {
  var str = '';
  for (var i = 0;i < data.length; i++) {
    str += "\\u" + data.charCodeAt(i).toString(16);
  }
  return str;
}

export function toChineseWords(data) {
  data = data.split("\\u");
  var str = '';
  for (var i = 0;i < data.length; i++) {
    str += String.fromCharCode(parseInt(data[i], 16));
  }
  return str;
}