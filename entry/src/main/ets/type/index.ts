export interface MList {
  "_id": string
  "name": string,
  "author": string,
  "picUrl": string,
  "uploader": string,
  "url": string,
  "likes": number,
  "isLikes": boolean,
}

export interface GroundItemRouterParams {
  groundUrl: string
}