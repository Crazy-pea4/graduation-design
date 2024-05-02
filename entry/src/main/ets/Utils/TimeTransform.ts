/* 单位：秒 */
enum Time {
  sec = 60 * 1000,
  min = Time.sec * 60
}

export const msTransform = function(ms: number) {
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