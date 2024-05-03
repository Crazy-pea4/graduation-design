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
