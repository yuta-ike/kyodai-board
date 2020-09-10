const toFormat = (date: Date): string => {
	return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
}
const toDate = (date: string): Date => {
	const [former, latter] = date.split(' ');
	const dates = former.split("/")
	const hours = latter.split(":")
	const origin = {
		year: parseInt(dates[0]),
		month: parseInt(dates[1]) - 1,
		date: parseInt(dates[2]),
		hour: parseInt(hours[0]),
		minute: parseInt(hours[1]),
	}
	const res = new Date();
	res.setFullYear(origin.year);
	res.setMonth(origin.month);
	res.setDate(origin.date);
	res.setHours(origin.hour);
	res.setMinutes(origin.minute);
	return res;
}

export { toFormat, toDate }