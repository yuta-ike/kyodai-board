import Schedule from "../models/schedule/schedule";
import Event from "../models/event/event";
import firestore, { Firestore } from "./firestore/firestore";

const addSchedule = async (clubId: string, eventId: string, schedule: Schedule & Event & { isValid: boolean } ) => {
	const { startAt, endAt, applyStartAt, applyEndAt } = schedule;
	const result = await firestore.collection("clubs").doc(clubId).collection('events').doc(eventId).collection('schedules').add({
		...schedule,
		startAt: new Date(startAt),
		endAt: new Date(endAt),
		applyStartAt: new Date(applyStartAt),
		applyEndAt: new Date(applyEndAt),
		clubRef: firestore.collection("clubs").doc(clubId),
		eventRef: firestore.collection("clubs").doc(clubId).collection("events").doc(eventId),
		createdAt: Firestore.FieldValue.serverTimestamp(),
		updatedAt: Firestore.FieldValue.serverTimestamp(),
		deletedAt: null,
	})
	return result
}

export default addSchedule