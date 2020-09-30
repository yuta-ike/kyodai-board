import adminAPI from "../../lib/auth/adminAPI"
import fetchClubs from "../../lib/repo/fetchClubs"

const getClubs = adminAPI(async (_, res) => {
	console.log("[CALL] GETCLUBS")
	const result = await fetchClubs()
	return res.status(200).send(result)
})

export default getClubs