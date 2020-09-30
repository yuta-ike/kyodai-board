import admin from 'firebase-admin'
import initFirebaseAdmin from '../../auth/initFirebaseAdmin'
const Firestore = admin.firestore
const firestore = Firestore()
export default firestore
export { Firestore }