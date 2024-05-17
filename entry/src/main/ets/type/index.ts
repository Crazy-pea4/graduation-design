export interface MList {
  "_id": string
  "name": string,
  "author": string,
  "picUrl": string,
  "uploader": string,
  "url": string,
  "likes": number,
  "likesList": string[]
}

export interface GroundItemRouterParams {
  groundId: string
  groundItem: GroundItemType
}

export interface GroundItemType {
  "_id": string,
  "musicId": string,
  "topicName": string,
  "topicIntroduction": string,
  "musicAuthor": string,
  "topicPic": string,
  "createdAt": string,
  "updatedAt": string,
}

export interface GroundDetailType {
  "_id": string,
  "title": string,
  "questioner": {
    "_id": string,
    "nickname": string,
    "phoneNumber": string,
    "avatarUrl": string
  },
  "topics": [
    string
  ],
  "createdAt": string,
  "updatedAt": string
}