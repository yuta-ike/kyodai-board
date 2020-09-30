import adminAPI from '../../../lib/auth/adminAPI'
import addEvent from '../../../lib/repo/addEvent'
import Event from "../../../lib/models/event/event"
import fetchClub from '../../../lib/repo/fetchClub'

const postEvent = adminAPI(async (req, res) => {
	const clubId = req.query.clubId as string
	const event: Event = req.body as Event
	// 団体情報を取得
	const club = await fetchClub(clubId)
	// イベントを追加
	const ref = await addEvent(clubId, {
		...event,
		club: club,
		isValid: true,
		isPublic: true,
	})
	// 追加したイベントを取得
	const snapshot = await ref.get()
	const data = snapshot.data()
	return res.status(200).send(data)
})

export default postEvent