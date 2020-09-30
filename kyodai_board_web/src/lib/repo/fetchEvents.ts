import firestore from "./firestore/firestore"
import Event from "../models/event/event"

const fetchEvents: (clubId: string) => Promise<(Event & { id: string })[]> = async (clubId: string) => {
	const snapshots = await firestore.collection('clubs').doc(clubId).collection('events').get()
	return snapshots.docs.map(snapshot => ({id: snapshot.id, ...snapshot.data() as Event}))
}

export default fetchEvents