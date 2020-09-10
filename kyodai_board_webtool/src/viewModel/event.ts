import { db } from "../firebase/firebase";
import { formDataType } from "../view/FormPage";
import { toDate } from "../utils/dateFormat";
import { getRand, getRandMul, getRandomImage } from "../utils/faker/faker";

let ids: string[] = [];
(async () => {
	const clubs = await db.collection('clubs').get();
	clubs.docs.forEach(doc => {
		ids.push(doc.id + '/' + doc.data().profile.name);
	})
})()

const eventModel: { [key: string]: formDataType } = {
	clubId: { type: 'select', options: ids, onUpdate: (value, updateValue) => {
		updateValue('hostName', value?.split('/')[1] ?? '');
		db.collection('clubs').doc(value?.split('/')[0]).get().then((qs) => {
			updateValue('clubType', qs.data()?.profile.clubType ?? '');
			updateValue('hostNickname', qs.data()?.profile.nickname ?? '');
		});
	}},
	// createdAt/ deletedAtを追加する
	// dayOfWeeksを追加する
	// hasQualofyLimitを追加する
	// iconImageを追加する
	// applyTypeにchat/webpageを追加
	hostName: { type: 'form' },
	hostNickname: { type: 'form' },
	clubType: { type: 'form' },
	isPublic: { type: 'bool' },
	title: { type: 'form' },
	catchphrase: { type: 'form' },
	description: { type: 'form' },
	imageUrl: { type: 'form' },
	place_display: { type: 'form' },
	campus: { type: 'select', options: ['yoshidaMain', 'yoshidaNorth', 'yoshidaSouth', 'yoshidaWest', 'yoshidaOthers', 'uji', 'katsura', 'others'] },
	meetingPlace_display: { type: 'form' },
	weatherCancel: { type: 'select', options: ['cancelWhenRain', 'cancelWhenHardRain', 'noCancel'] },
	weatherCancel_display: { type: 'form' },
	contact: { type: 'form' },
	contactCurrentDay: { type: 'form' },
	qualifiedGrades: { type: 'multiselect', options: ['first', 'newFirst', 'second', 'newSecond', 'third', 'newThird', 'fourth', 'newFourth', 'postFirst', 'newPostFirst', 'postSecond', 'newPostSecond'], init: ['first', 'second'] },
	entryQualify_display: { type: 'form' },
	belongings: { type: 'form' },
	notes: { type: 'form' },
	applyType: { type: 'multiselect', options: ['app', 'twitter', 'line', 'facebook', 'email', 'others', 'none'], init: ['app'] },
	applyType_display: { type: 'form' },
}

const sendEvent = (_data: { [key: string]: any }) => {
	const { clubId, ...eventData } =
		Object.fromEntries(Object.entries(_data).map(([key, value]) => {
			if (key === 'genre') return [key, (value as String).trim().split(' ')];
			if (eventModel[key].type === 'int') return [key, parseInt(value)];
			if (eventModel[key].type === 'ratio') return [key, Math.floor(parseFloat(value) * 10.0) / 10.0];
			if (eventModel[key].type === 'bool') return [key, value === "true"];
			if (eventModel[key].type === 'date') {
				return [key, toDate(value)];
			}
			return [key, value]
		}));

	db.collection('clubs').doc(clubId.split('/')[0])
		.collection('events').add(eventData);
}

const randomGenEvent: (() => { [key: string]: (string | boolean | number | string[] | Date) }) = () => {


	return {
		isPublic: "true",
		title: getRand(["新入生歓迎会", "活動説明会", "体験会"]),
		catchphrase: getRand(["気軽にお越しください！", "初心者も歓迎！！"]),
		description: getRand(["新入生向けに活動内容を説明します。後半には体験会も行うのでぜひ参加してください。"]),
		imageUrl: getRandomImage(),
		place_display: getRand(['農学部グラウンドで行います', '京大体育館で行います', '時計台広場に集合してください']),
		campus: getRand(['yoshidaMain', 'yoshidaNorth', 'yoshidaSouth', 'yoshidaWest', 'yoshidaOthers', 'uji', 'katsura', 'others']),
		meetingPlace_display: getRand(['時計台前集合です', '現地集合です。部屋の前まで来てください']),
		weatherCancel: getRand(['cancelWhenRain', 'cancelWhenHardRain', 'noCancel']),
		weatherCancel_display: '雨天中止です。当日Twitterでお知らせします。',
		qualifiedGrades: ['first', ...getRandMul(['first', 'newFirst', 'second', 'newSecond', 'third', 'newThird', 'fourth', 'newFourth', 'postFirst', 'newPostFirst', 'postSecond', 'newPostSecond'])],
		contact: getRand(['新歓用TwitterのDMにお願いします。', 'sinkan@example.com']),
		contactCurrentDay: getRand(['新歓用TwitterのDMにお願いします。', 'sinkan@example.com']),
		entryQualify_display: '1、2回生が対象ですが、3回生以上でも参加可能です。',
		belongings: '運動できる服装・靴、飲み物（各自持参）',
		notes: '体験会ですので運動のできる服装でお越しください。',
		applyType: getRandMul(['app', 'twitter', 'line', 'facebook', 'email', 'others', 'none']),
		applyType_display: '締め切り後にキャンセルが出た場合はTwitterにて先着順で募集します。',
	}
}

export { eventModel, sendEvent, randomGenEvent };

