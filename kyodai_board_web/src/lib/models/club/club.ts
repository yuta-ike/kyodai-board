import getRandom, { getRandomAlphabet, getRandomIcon, getRandomImage, getRandomInt, getRandomMul, getRandomName, getRandomShortName, getRandomSportsName } from "../../../utils/getRandom"
import { getCampuses, getClubTypes, getDaysOfWeek, getFreqs, getSubClubTypes, getUnivGrades } from "../utils/enumValues"
import ClubPrivate from "./clubPrivate"

export type ClubType = 'sportsUnion' | 'sports' | 'culture' | 'music' | 'study' | 'tech' | 'business' | 'job' | 'others'
export type SubClubType = Exclude<ClubType, 'others'> | 'none'
export type Freq = 'almostEveryday'| 'fiveTimesPerWeek'| 'fourTimesPerWeek'| 'threeTimesPerWeek'| 'twicePerWeek'| 'oncePerWeek'| 'twicePerMonth'| 'oncePerMonth'| 'oncePerTwoMonth'| 'oncePerThreeMonth'| 'threeTimesPerYear'| 'oncePerHalfYear'| 'oncePerYear'| 'moreRare'| 'none' | 'others'
export type Campus = 'yoshida'| 'uji'| 'katsura'| 'others'
export type DayOfWeek = 'sunday'| 'monday'| 'tuesday'| 'wednesday'| 'thursday'| 'friday'| 'saturday' | 'irregular'
export type UnivGrade = 'first' | 'second' | 'third' | 'fourth' | 'postFirst' | 'postSecond' | 'preFirst' | 'older'

// genreの対応
export default class Club{
	constructor(
		readonly clubPrivate: ClubPrivate,
		readonly name: string,
		readonly displayName: string,
		readonly genre: [string?, string?, string?],
		readonly imageUrl: string,
		readonly iconImageUrl: string,
		readonly clubType: ClubType,
		readonly subClubType: SubClubType,
		readonly isOfficial: boolean,
		readonly isIntercollege: boolean,
		readonly isCompany: boolean,
		readonly hasSchoolRestrict: boolean,
		readonly schoolRestrict_display: string,
		readonly qualifiedGrades: UnivGrade[],
		readonly qualifiedGrades_display: string,
		// readonly competitionFreq: Freq,
		readonly competition_display: string,
		readonly description: string,
		readonly memberCount: number,
		readonly genderRatio: number,
		readonly kuRatio: number,
		readonly member_display: string,
		readonly place_display: string,
		readonly cost_display: string,
		readonly campus: Campus[],
		// readonly freq: Freq,
		readonly freq_display: string,
		readonly daysOfWeek: DayOfWeek[],
		readonly obligation: number,
		readonly obligation_display: string,
		readonly motivation: number,
		readonly motivation_display: string,
		// readonly eventFreq: Freq,
		readonly event_display: string,
		// readonly drinkingFreq: Freq,
		readonly drinking_display: string,
		// readonly tripFreq: Freq,
		readonly trip_display: string,
		readonly initialChatMessage: string,
		readonly publicEmail: string,
		readonly publicEmailDescription: string,
		readonly publicEmail2: string,
		readonly publicEmail2Description: string,
		readonly publicPhoneNumber: string,
		readonly publicPhoneNumberDescription: string,
		readonly twitterUrl: string,
		readonly twitterUrlDescription: string,
		readonly twitterUrl2: string,
		readonly twitterUrl2Description: string,
		readonly facebookUrl: string,
		readonly facebookUrlDescription: string,
		readonly lineId: string,
		readonly lineIdDescription: string,
		readonly lineId2: string,
		readonly lineId2Description: string,
	){}
}

export const clubProfileForm: { [P in keyof Club]?: [string, string, boolean, Club[P]?] } = {
	name: ["string","団体名",true, ""],
	displayName: ["string", "表示名", true,""],
	genre: ["genre", "ジャンル", false, ["", "", ""]],
	imageUrl: ["string","画像URL", true, ""],
	iconImageUrl: ["string","アイコン画像URL", true, ""],
	clubType: ['ClubType', "団体種別", true, "sportsUnion"],
	subClubType: ['SubClubType', "団体種別（サブ）", false, "sports"],
	isOfficial: ["boolean","公認団体", true, true],
	isIntercollege: ["boolean","インカレ団体", true, true],
	isCompany: ["boolean","会社団体", true, false],
	hasSchoolRestrict: ["boolean", "学部制限の有無", true, false],
	schoolRestrict_display: ["string","学部制限について", false, ""],
	qualifiedGrades: ["UnivGrade[]", "入会可能学年", true, getUnivGrades()],
	qualifiedGrades_display: ["string", "入会可能制限について", true, ""],
	// competitionFreq: ["Freq", "大会・発表会の頻度", false, "oncePerHalfYear"],
	competition_display: ["string","大会・発表会について", false, ""],
	description: ["string","団体説明・アピールポイント", true, ""],
	memberCount: ["number", "所属人数", true, 10],
	genderRatio: ["number","男女比", true, 0.5],
	kuRatio: ["number","京大生比", true, 0.8],
	member_display: ["string","メンバー紹介", true, ""],
	place_display: ["string","活動場所", true, ""],
	cost_display: ["string", "費用", true, '年会費は1000円です。他に活動に必要な用具を購入する必要があります。'],
	campus: ["Campus[]","活動キャンパス", true, ["yoshida"]],
	daysOfWeek: ["DayOfWeek[]","活動曜日", true, ["wednesday"]],
	// freq: ["Freq", "活動頻度", true, "oncePerWeek"],
	freq_display: ["string","活動頻度の説明", true, "毎週水曜に活動しています"],
	obligation: ['number', "全員参加or自由参加", false, 1],
	obligation_display: ["string","全員参加or自由参加説明", false, "完全任意参加です"],
	motivation: ["number", "モチベーション", false, 5],
	motivation_display: ["string","モチベーションの説明", false, "大会に向けて練習しています"],
	// eventFreq: ["Freq", "イベント頻度", false, "oncePerThreeMonth"],
	event_display: ["string","イベントについて", false,"定期的にイベントを企画しています"],
	// drinkingFreq: ["Freq", "飲み会頻度", false, "oncePerThreeMonth"],
	drinking_display: ["string","飲み会について", false, "イベント後に飲み会を実施する場合が多いです。"],
	// tripFreq: ["Freq","旅行・合宿頻度", false, "oncePerYear"],
	trip_display: ["string","旅行・合宿について", false, "例年は夏休みに合宿を実施しています"],
	initialChatMessage: ["string", "チャットの初期メッセージ", false, "興味を持っていただきありがとうございます！お気軽に話しかけてください♪"],
	publicEmail: ["string","公開メールアドレス1", false, "kyodai.board@example.com"],
	publicEmailDescription: ["string", "公開メールアドレス1の説明", false, "サークル用メールアドレスです"],
	publicEmail2: ["string", "公開メールアドレス2", false, ""],
	publicEmail2Description: ["string", "公開メールアドレス2の説明", false, ""],
	publicPhoneNumber: ["string", "電話番号", false, ""],
	publicPhoneNumberDescription: ["string", "電話番号の説明", false, ""],
	twitterUrl: ["string", "TwitterURL1", false, ""],
	twitterUrlDescription: ["string", "TwitterURL1の説明", false, ""],
	twitterUrl2: ["string", "TwitterURL2", false, ""],
	twitterUrl2Description: ["string", "TwitterURL2の説明", false, ""],
	facebookUrl: ["string", "FaceBookURL", false, ""],
	facebookUrlDescription: ["string", "FaceBookURLの説明", false, ""],
	lineId: ["string", "LINE ID", false, ""],
	lineIdDescription: ["string", "LINEアカウントの説明", false, ""],
	lineId2: ["string", "LINE ID 2", false, ""],
	lineId2Description: ["string", "LINEアカウント2の説明", false, ""],
}

export const profileFormRandom = (): Partial<Club> => ({
	name: getRandomName(),
	displayName: getRandomShortName(),
	genre: getRandomMul([getRandomSportsName(), getRandomSportsName(), getRandomSportsName()]).slice(0, 3) as [string?, string?, string?],
	imageUrl: getRandomImage(),
	iconImageUrl: getRandomIcon(),
	clubType: getRandom(getClubTypes()),
	subClubType: getRandom(getSubClubTypes()),
	isOfficial: getRandom([true, false]),
	isIntercollege: getRandom([true, false]),
	isCompany: getRandom([true, false]),
	hasSchoolRestrict: getRandom([true, false]),
	schoolRestrict_display: "",
	qualifiedGrades: getRandomMul(getUnivGrades()),
	qualifiedGrades_display: "",
	// competitionFreq: getRandom(getFreqs()),
	competition_display: getRandom(["年に2回、夏と秋に大会があります", "大会はありません", "2ヶ月に1回、サークル内での発表があります"]),
	description: `みんなで楽しく活動しています。練習にはOB・OGさんがいらっしゃってくださり、指導いただいています。\nイベントや行事などの練習以外の活動も積極的に行っており、メンバーの中がとても良いです。\n回生問わずメンバーを募集しているので、ぜひ見学会に来てください！`,
	memberCount: getRandomInt(5, 100),
	genderRatio: Math.floor(Math.random() * 10)/10,
	kuRatio: Math.floor(Math.random() * 10) / 10,
	member_display: getRandom([`1回生10人、2回生20人、3回生15人で活動しています。`, '学部生15人で活動しています。']),
	place_display: getRandom([`主に農学部グラウンドで活動しています。状況によっては市民グラウンドを利用することもあります`, '法学部教室で活動しています']),
	cost_display: getRandom(['年会費は1000円です。他に活動に必要な用具を購入する必要があります。', '必要経費は特にありません']),
	campus: getRandomMul(getCampuses()),
	daysOfWeek: getRandomMul(getDaysOfWeek()),
	// freq: getRandom(getFreqs()),
	freq_display: getRandom(['毎週月曜と水曜に活動しています。金曜には自主練をしています。', '月に1度に全員集まってのMTGがあります。それ以外は自由に活動しています', '毎週月曜から金曜の昼休みに活動しています']),
	obligation: getRandomInt(1, 5),
	obligation_display: getRandom(["基本自由参加です", "原則全員参加です", "全員参加の日と自由参加の日があります"]),
	motivation: getRandomInt(1, 5),
	motivation_display: getRandom(["全員が大会を意識して取り組んでいます", "各々の好きな活動をしています。", "NFを目標に頑張っています"]),
	// eventFreq: getRandom(getFreqs()),
	event_display: getRandom(["定期的にイベントを企画しています。年に5〜6回行っています", "サークル内でのイベントは特にありません"]),
	// drinkingFreq: getRandom(getFreqs()),
	drinking_display: getRandom(["毎月飲み会があります。自由参加です。", "年に1回から2回、ほぼ全員が参加して飲み会を行っています。", "特にありません"]),
	// tripFreq: getRandom(getFreqs()),
	trip_display: getRandom(["関西を中心に2泊3日で合宿を行っています", "年に4回、合宿を兼ねた部内旅行を企画しています。", "合宿はありません"]),
	initialChatMessage: getRandom(["興味を持っていただきありがとうございます！\n\nお気軽に話しかけてください！", "こんにちは！何か質問等ありましたら遠慮なくお聞きください。"]),
	publicEmail: [getRandomAlphabet()].map(str => `${str.repeat(Math.floor(Math.random() * 3)) + 1}@example.com`)[0],
	publicEmailDescription: getRandom(["サークルの連絡用メールアドレスです", "新歓用のメールアドレスです"]),
	publicEmail2: "",
	publicEmail2Description: "",
	publicPhoneNumber: "",
	publicPhoneNumberDescription: "",
	twitterUrl: "https://twitter.com/kyodai_catarog",
	twitterUrlDescription: getRandom(["サークル公式Twitter", "新歓用アカウント"]),
	twitterUrl2: "",
	twitterUrl2Description: "",
	facebookUrl: "",
	facebookUrlDescription: "",
	lineId: "",
	lineIdDescription: "",
	lineId2: "",
	lineId2Description: "",
})