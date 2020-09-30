import * as admin from 'firebase-admin'
import initFirebaseAdmin from './initFirebaseAdmin'

export const verifyIdToken = (token: string) => {
  console.log("[CALL] initFirebaseAdmin()")
  initFirebaseAdmin()
  return admin
    .auth()
    .verifyIdToken(token)
    .catch((error) => {
      throw error
    })
}
