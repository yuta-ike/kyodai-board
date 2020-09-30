import { NextApiRequest, NextApiResponse } from "next"
import { verifyIdToken } from "./firebaseAdmin"

type NextAPI = (req: NextApiRequest, res: NextApiResponse) => unknown

const adminAPI = (api: NextAPI) => {
	return async (req: NextApiRequest, res: NextApiResponse) => {
		console.log("[CALL] API")
		const token = req.headers.token as any

		try {
			await verifyIdToken(token)
			// TODO: Adminユーザー判定
			return api(req, res)
		} catch (error) {
			console.log(error)
			return res.status(401).send('You are unauthorised')
		}
	}
}

export default adminAPI