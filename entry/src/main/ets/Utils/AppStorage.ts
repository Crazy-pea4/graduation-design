export enum PersistentKey {
  token = 'token'
}

export enum StateKey {
  musicDuration = 'musicDuration',
}

class APPSTATE {
  public setState<T>(key: string, val: T): void {
    AppStorage.SetOrCreate(key, val)
  }

  public getState<T>(key: string): T {
    const res = AppStorage.Get(key) as T
    console.log(`AppStorage.Get: ${key}, res: ${res}`)
    return res;
  }

  public DelState(key: string): boolean {
    const res = AppStorage.Delete(key)
    console.log(`AppStorage.Delete: ${key}, res: ${res}`)
    return res
  }
}

class PERSISTENTSTATE {
  public setStorage<T>(key: string, val: T) {
    PersistentStorage.PersistProp(key, val)
  }

  public getStorage<T>(key: string): T {
    const res = AppStorage.Get(key) as T
    console.log(key, res)
    return res;
  }

  public DelStorage(key: string): boolean {
    const res = AppStorage.Delete(key)
    console.log(`AppStorage.Delete: ${key}, res: ${res}`)
    return res
  }
}

export const AppState = new APPSTATE();

export const PersistentState = new PERSISTENTSTATE();