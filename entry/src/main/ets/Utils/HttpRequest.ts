// HttpUtil.ets
import { BASE_URL } from '../const/index';
import http from '@ohos.net.http';
import { showToast } from './utils';
import { AppState } from './AppStorage';

export interface ServerData {
  [key: string]: string | number,
  code: number,
  data: any,
  message: string
}

async function base(url: string, method: http.RequestMethod, extraData?: any) {
  url = BASE_URL + url
  const httpRequest = http.createHttp();
  var header = {
    'Content-Type': 'application/json',
    'token': AppState.getState('token') || ''
  }
  let serverData: ServerData = { code: 0, data: '', message: '' };

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

export const httpRequestGet = async (url: string, params?: any) => await base(url, http.RequestMethod.GET, params)

export const httpRequestPost = async (url: string, params: any) => await base(url, http.RequestMethod.POST, params)

export const httpRequestDel = async (url: string) => await base(url, http.RequestMethod.DELETE)

export const httpRequestPut = async (url: string, params: any) => await base(url, http.RequestMethod.PUT, params)
