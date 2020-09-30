import ClubPrivate from "../models/club/clubPrivate";
import Club from "../models/club/club";
import firestore from "./firestore/firestore";

const fetchClub: (clubId: string) => Promise<Club> = async (clubId: string) => {
	const clubSnapshot = await firestore.collection('clubs').doc(clubId).get()
	return clubSnapshot.data() as Club
}

export default fetchClub