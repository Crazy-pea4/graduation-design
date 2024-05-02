export enum StateKey {
  musicDuration = 'musicDuration'
}

class APPSTATE {
  public setState<T>(key: string, val: T): void {
    AppStorage.SetOrCreate(key, val)
  }

  public getState<T>(key: string): T {
    const res = AppStorage.Get(key) as T
    console.log(key, res)
    return res;
  }
}

export const AppState = new APPSTATE()