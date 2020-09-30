import adminAPI from "../../../../lib/auth/adminAPI";
import Schedule from "../../../../lib/models/schedule/schedule";
import addSchedule from "../../../../lib/repo/addSchedule";
import fetchEvent from "../../../../lib/repo/fetchEvent";

const postSchedule = adminAPI(async (req, res) => {
	const clubId = req.query.clubId as string
	const eventId = req.query.eventId as string
	const schedule = req.body as Schedule
	const event = await fetchEvent(clubId, eventId)
	const ref = await addSchedule(clubId, eventId, {
		...event,
		...schedule,
		isValid: true,
	})
	const result = await ref.get()
	return res.status(200).send(result)
})

export default postSchedule