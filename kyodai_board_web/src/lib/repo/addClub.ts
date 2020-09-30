import Club from '../models/club/club'
import firestore, { Firestore } from './firestore/firestore'

const addClub = async (_club: Club) => {
	const { clubPrivate, ...club } = _club

	const result = await firestore.collection("clubs").add({
		...club,
		createdAt: Firestore.FieldValue.serverTimestamp(),
		updatedAt: Firestore.FieldValue.serverTimestamp(),
		isValid: false,
		isPublic: false,
		hasDeleted: false,
	})

	await firestore.collection("clubs").doc(result.id).collection("private").doc(result.id).set({
		...clubPrivate,
		createdAt: Firestore.FieldValue.serverTimestamp(),
		updatedAt: Firestore.FieldValue.serverTimestamp(),
		deletedAt: null,
		userRefs: [firestore.collection("users").doc("userRef1"), firestore.collection("users").doc("userRef2"),],
	})
	return result
}

export default addClub
