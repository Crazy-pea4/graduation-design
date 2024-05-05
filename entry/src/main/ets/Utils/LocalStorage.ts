const initialState = {
  isPlaying: false,
  musicTitle: '',
  musicAuthor: '',
  musicId: 0,
}

export const storage = new LocalStorage(initialState);