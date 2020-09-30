import getRandom, { getRandomImage, getRandomMul } from "../../../utils/getRandom";
import { Campus, UnivGrade } from "../club/club";
import { getApplyMethods, getCampuses, getUnivGrades, getWeatherCancels } from "../utils/enumValues";


export type WeatherCancel = 'cancelWhenRain' | 'cancelWhenHardRain' | 'noCancel' | 'others'
export type ApplyMethod = 'appform' | 'appchat' | 'webpage' | 'googleform' | 'twitter' | 'line' | 'facebook' | 'email' | 'others' | 'noneed'

export default class Event{
	constructor(
		readonly title: string,
		readonly description: string,
		readonly imageUrl: string,
		readonly place_display: string,
		readonly campus: Campus,
		readonly meetingPlace_display: string,
		readonly weatherCancel: WeatherCancel,
		readonly weatherCancel_display: string,
		readonly contact: string,
		readonly contactCurrentDay: string,
		readonly hasGradesLimit: boolean,
		readonly qualifiedGrades: UnivGrade[],
		readonly qualifiedGrades_display: string,
		readonly belongings: string,
		readonly notes: string,
		readonly applyMethods: ApplyMethod[],
		readonly apply_display: string,
	){}
}

export const eventForm: {[P in keyof Event]: [string, string, boolean, Event[P]?]} = {
	title: ["string", "イベントタイトル", true, ""],
	description: ["string", "イベントの説明", true, ""],
	imageUrl: ["string", "画像URL", true, ""],
	place_display: ["string", "実施場所", true, ""],
	campus: ["Campus", "実施キャンパス", true, "yoshida"],
	meetingPlace_display: ["string", "集合場所", true, ""],
	weatherCancel: ["WeatherCancel", "雨天時の対応", true, "cancelWhenHardRain"],
	weatherCancel_display: ["string", "雨天時の対応の説明", true, ""],
	contact: ["string", "連絡先", true, ""],
	contactCurrentDay: ["string", "当日の連絡先", true, ""],
	hasGradesLimit: ["boolean", "学年制限", true, false],
	qualifiedGrades: ["UnivGrade", "参加可能な学年", true, getUnivGrades()],
	qualifiedGrades_display: ["string", "参加可能な学年の説明", true, ""],
	belongings: ["string", "持ち物", true, ""],
	notes: ["string", "注意事項", true, ""],
	applyMethods: ["ApplyMethod", "応募方法", true, getApplyMethods()],
	apply_display: ["string", "応募方法の説明", true, ""],
}

export const eventFormRandom: (() => { [P in keyof Event]: Event[P] }) = () => ({
	title: getRandom(["【オンライン開催】オンライン新歓で先輩と話そう！", "サークル活動体験会（参加可）", "オンライン開催・履修相談会", "【入退室自由】オンライン説明会 & 懇親会"]),
	description: getRandom(["新入生向けに活動内容を説明します。後半には体験会も行うのでぜひ参加してください。", "サークル体験会を行います！ぜひご参加ください！！", "オンライン新歓です。先輩や同期とワイワイ話しましょう！（入退室自由です）", "履修で困っていることがあればサポートします！お気軽にご参加ください"]),
	imageUrl: getRandomImage(),
	place_display: getRandom(["オンライン（Zoom）", "農学部グラウンド", "吉田キャンパス内の教室", "市民体育館"]),
	campus: getRandom(getCampuses()),
	meetingPlace_display: getRandom(["オンライン（Zoom）", "農学部グラウンド", "吉田キャンパス内の教室", "市民体育館"]),
	weatherCancel: getRandom(getWeatherCancels()),
	weatherCancel_display: "",
	contact: getRandom(["サークル公式TwitterにDMをください", "hogehoge@example.com"]),
	contactCurrentDay: getRandom(["サークル公式TwitterにDMをください", "hogehoge@example.com"]),
	hasGradesLimit: false,
	qualifiedGrades: getUnivGrades(),
	qualifiedGrades_display: "",
	belongings: getRandom(["運動できる靴と服装・水分","特になし"]),
	notes: getRandom(["当日飛び入り参加も可能です！", ""]),
	applyMethods: getRandomMul(getApplyMethods()),
	apply_display: "",
})