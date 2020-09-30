import adminAPI from '../../lib/auth/adminAPI'
import Club from '../../lib/models/club/club'
import ClubPrivate from '../../lib/models/club/clubPrivate'
import addClub from '../../lib/repo/addClub'

const postClub = adminAPI(async (req, res) => {
	const club: Club = req.body as Club
	// データを追加
	const ref = await addClub(club)
	// 追加したデータを取得
	const snapshot = await ref.get()
	const data = snapshot.data()
	return res.status(200).send(data)
})

export default postClub