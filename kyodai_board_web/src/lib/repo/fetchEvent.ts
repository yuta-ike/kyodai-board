import Event from "../models/event/event"
import firestore from "./firestore/firestore"

const fetchEvent: (clubId: string, eventId: string) => Promise<Event> = async (clubId: string, eventId: string) => {
	const snapshot = await firestore.collection('clubs').doc(clubId).collection('events').doc(eventId).get()
	return snapshot.data() as Event
}

export default fetchEvent