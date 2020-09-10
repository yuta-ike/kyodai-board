import { formDataType } from "../view/FormPage";
import { db } from "../firebase/firebase";
import { toFormat, toDate } from "../utils/dateFormat";
import { getRand, getRandMul } from "../utils/faker/faker";

let ids: string[] = [];
(async () => {
	const clubs = await db.collection('clubs').get();
	clubs.docs.forEach(doc => {
		ids.push(doc.id + '/' + doc.data().profile.name);
	})
})()

// createdAt/ deletedAtを追加する
// dayOfWeeksを追加する
// hasQualofyLimitを追加する
// iconImageを追加する
// eventIdを追加する
const scheduleModel: { [key: string]: formDataType } = {
	clubId: { type: 'select', options: ids },
	eventId: { type: 'form' },
	startAt: { type: 'date', init: toFormat(new Date()) },
	endAt: { type: 'date', init: toFormat(new Date()) },
	time_display: { type: 'form' },
	applyStartAt: { type: 'date', init: toFormat(new Date()) },
	applyEndAt: { type: 'date', init: toFormat(new Date()) },
};

const sendSchedule = async (_data: { [key: string]: any }) => {
	const { clubId, eventId, ...scheduleData } =
		Object.fromEntries(Object.entries(_data).map(([key, value]) => {
			if (scheduleModel[key].type === 'int') return [key, parseInt(value)];
			if (scheduleModel[key].type === 'ratio') return [key, Math.floor(parseFloat(value) * 10.0) / 10.0];
			if (scheduleModel[key].type === 'bool') return [key, value === "true"];
			if (scheduleModel[key].type === 'date'){
				return [key, toDate(value)];
			}
			return [key, value]
		}));
	console.log(eventId, clubId)
	const eventRef = db.collection('clubs').doc(clubId.split('/')[0]).collection('events').doc(eventId)
	const eventData = await eventRef.get();

	console.log(eventData)
	console.log(eventData.data())
	console.log({
		...eventData.data(),
		...scheduleData,
		clubId: clubId.split('/')[0],
		eventRef: eventRef,
	})

	db.collection('clubs').doc(clubId.split('/')[0])
		.collection('events').doc(eventId)
		.collection('schedules').add({
			...eventData.data(),
			...scheduleData,
			clubId: clubId.split('/')[0],
			eventRef: eventRef,
		});
}

const randomGenSchedule: (() => { [key: string]: (string | boolean | number | string[] | Date) }) = () => {
	const now = new Date();
	now.setDate(now.getDate() + Math.floor(Math.random() * 10) + 1)
	now.setMinutes(0)
	now.setSeconds(0)
	const startAt = new Date(now.getTime());
	const endAt = new Date(startAt.getTime());
	endAt.setHours(startAt.getHours() + 1 + Math.floor(Math.random() * 2));

	const applyStartAt = new Date(startAt.getTime());
	applyStartAt.setDate(startAt.getDate() - Math.floor(Math.random() * 10) - 2)
	const applyEndAt = new Date(applyStartAt.getTime());
	applyEndAt.setDate(applyStartAt.getDate() + 1 + Math.floor(Math.random() * 3));


	return {
		startAt: toFormat(startAt),
		endAt: toFormat(endAt),
		time_display: `${endAt.getHours()}時終了予定ですが1時間ほど延長する可能性があります`,
		applyStartAt: toFormat(applyStartAt),
		applyEndAt: toFormat(applyEndAt),
	}
}

export { scheduleModel, sendSchedule, randomGenSchedule };