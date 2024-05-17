// HttpUtil.ets
import { BASE_URL } from '../const/index';
import http from '@ohos.net.http';
import { showToast } from './utils';
import { AppState, PersistentKey } from './AppStorage';
import router from '@ohos.router';

export interface ServerData {
  [key: string]: string | number,
  code: number,
  data: any,
  message: string
}

async function base(url: string, method: http.RequestMethod, extraData = {}, isCreateAt = false, needJumpLogin = false) {
  if(!AppState.getState(PersistentKey.token) && needJumpLogin) {
    showToast('需要先登录')
    setTimeout(() => {
      router.pushUrl({url: "pages/Login"})
    }, 1500)
    return;
  }

  url = BASE_URL + url
  const httpRequest = http.createHttp();
  var header = {
    'Content-Type': 'application/json',
    'token': AppState.getState('token') || ''
  }
  let serverData: ServerData = { code: 0, data: '', message: '' };

  if(isCreateAt) {
    extraData = {
      createdAt: "1",
      updatedAt: "1",
      ...extraData
    }
  }

  try {
    let res = await httpRequest.request(url, {
      method,
      header,
      extraData
    });
    // 处理数据，并返回
    if (res.responseCode === 200) {
      // 获取返回数据
      serverData = JSON.parse(res.result as string);
      ;
    } else {
      serverData = JSON.parse(res.result as string);
    }

    console.info(JSON.stringify(serverData), 'httpRequestData success')
    showToast(serverData.message)
    return serverData;
  } catch (err) {
    serverData.message = '调用接口失败';
    console.info(JSON.stringify(err), JSON.stringify(serverData), 'httpRequestData Failed')

    return serverData;
  }
}

export const httpRequestGet = async (url: string, params?: any, isCreateAt: boolean = false, needJumpLogin: boolean = false) => await base(url, http.RequestMethod.GET, params, isCreateAt, needJumpLogin)

export const httpRequestPost = async (url: string, params: any, isCreateAt: boolean = false, needJumpLogin: boolean = false) => await base(url, http.RequestMethod.POST, params, isCreateAt, needJumpLogin)

export const httpRequestDel = async (url: string) => await base(url, http.RequestMethod.DELETE)

export const httpRequestPut = async (url: string, params: any) => await base(url, http.RequestMethod.PUT, params)
