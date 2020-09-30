import Club from "../models/club/club"
import Event from "../models/event/event"
import firestore, { Firestore } from "./firestore/firestore"

const addEvent = (clubId: string, event: Event & { club: Club, clubId: string, isValid: boolean, isPublic: boolean }) => {
	return firestore.collection("clubs").doc(clubId).collection("events").add({
		...event,
		createdAt: Firestore.FieldValue.serverTimestamp(),
		updatedAt: Firestore.FieldValue.serverTimestamp(),
		deletedAt: null,
	})
}

export default addEvent