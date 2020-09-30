import Schedule from "../models/schedule/schedule";
import Event from "../models/event/event";
import firestore, { Firestore } from "./firestore/firestore";

const addSchedule = async (clubId: string, eventId: string, schedule: Schedule & Event & { isValid: boolean, eventId: string, clubId: string } ) => {
	const result = await firestore.collection("clubs").doc(clubId).collection('events').doc(eventId).collection('schedules').add({
		...schedule,
		createdAt: Firestore.FieldValue.serverTimestamp(),
		updatedAt: Firestore.FieldValue.serverTimestamp(),
		deletedAt: null,
	})
	return result
}

export default addSchedule