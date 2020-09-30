export default class Schedule {
	constructor(
		readonly startAt: string,
		readonly endAt: string,
		readonly time_display: string,
		readonly applyStartAt: string,
		readonly applyEndAt: string,
		readonly apply_time_display: string,
	) { }
}

export const scheduleForm: { [P in keyof Schedule]: [string, string, boolean, Schedule[P]?] } = {
	startAt: ["Date", "開始時刻", true, new Date().toISOString()],
	endAt: ["Date", "終了時刻", true, new Date().toISOString()],
	time_display: ["string", "時刻について", true, ""],
	applyStartAt: ["Date", "申し込み開始時刻", true, new Date().toISOString()],
	applyEndAt: ["Date", "申し込み終了時刻", true, new Date().toISOString()],
	apply_time_display: ["string", "申し込み時刻について", true, ""],
}

export const scheduleFormRandom: (() => { [P in keyof Schedule]: Schedule[P] }) = () => {
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
		startAt: startAt.toISOString(),
		endAt: endAt.toISOString(),
		time_display: `${endAt.getHours()}時終了予定ですが1時間ほど延長する可能性があります`,
		applyStartAt: applyStartAt.toISOString(),
		applyEndAt: applyEndAt.toISOString(),
		apply_time_display: `${applyEndAt.getHours()}時までにご連絡ください`,
	}
}