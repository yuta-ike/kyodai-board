import adminAPI from "../../../lib/auth/adminAPI"
import fetchClubs from "../../../lib/repo/fetchClubs"
import fetchEvents from "../../../lib/repo/fetchEvents"

const getClubs = adminAPI(async (req, res) => {
	const clubId = req.query.clubId as string
	const result = await fetchEvents(clubId)
	return res.status(200).send(result)
})

export default getClubs