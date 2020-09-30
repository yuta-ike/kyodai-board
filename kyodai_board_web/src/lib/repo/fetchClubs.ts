import Club from "../models/club/club"
import firestore from "./firestore/firestore"

const fetchClubs = async () => {
	console.log("[CALL] firestore.colle...")
	const clubSnapshots = await firestore.collection('clubs').get()
	return clubSnapshots.docs.map(snapshot => ({...snapshot.data(), id: snapshot.id }) as (Club & {id: string}))
}

export default fetchClubs