import { formDataType } from "../view/FormPage";
import { db } from "../firebase/firebase";
import { getRand, getRandMul, getRandInt, getRandFloat, getRandomClubName, getRandomNickName, getRandomSportsName, getRandomImage, getRandomIcon } from "../utils/faker/faker";

// TODO: initialMessageを追加
const freqOptions = ['almostEveryday', 'fiveTimesPerWeek', 'fourTimesPerWeek', 'threeTimesPerWeek', 'twicePerWeek', 'oncePerWeek', 'twicePerMonth', 'oncePerMonth', 'oncePerTwoMonth', 'oncePerThreeMonth', 'threeTimesPerYear', 'oncePerHalfYear', 'oncePerYear', 'moreRare', 'others']
const data: { [key: string]: formDataType } = {
	accountType: { type: 'select', options: ['temporary', 'normal', 'silver', 'gold'], init: 'normal' },
	isValid: { type: 'bool', init: true },
	isRegisterCompleted: { type: 'bool', init: true },
	name: { type: 'form', init: '京都大学プログラミング同好会' },
	nickname: { type: 'form', init: 'プロ同' },
	genre: { type: 'form', init: 'プログラミング IT 情報' },
	imageUrl: { type: 'form', init: 'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/sample.jpg?alt=media&token=296e663c-19c8-4123-bdd0-2941f7648dc7' },
	iconImageUrl: { type: 'form', init: 'https://3.bp.blogspot.com/---bC5f3l67Y/VCIkKXEkX8I/AAAAAAAAmkc/xOSiXCTwebk/s170/monster12.png' },
	clubType: { type: 'select', options: ['sportsUnion', 'sports', 'culture', 'music', 'study', 'business', 'job', 'others'], init: 'study' },
	isOfficial: { type: 'bool', init: true },
	isIntercollege: { type: 'bool', init: true },
	isOnlyKU: { type: 'bool', init: false },
	isCompany: { type: 'bool', init: false },
	hasSchoolRestrict: { type: 'bool', init: false },
	competitionFreq: { type: 'select', options: freqOptions, init: 'oncePerWeek' },
	competition_display: { type: 'form', init: '毎週水曜日に活動しています' },
	description: { type: 'form' },
	memberCount: { type: 'int' },
	genderRatio: { type: 'ratio' },
	kuRatio: { type: 'ratio' },
	place_display: { type: 'form' },
	campus: { type: 'select', options: ['yoshidaMain', 'yoshidaNorth', 'yoshidaSouth', 'yoshidaWest', 'yoshidaOthers', 'uji', 'katsura', 'others'] },
	freq: { type: 'select', options: freqOptions },
	freq_display: { type: 'form' },
	daysOfWeek: { type: 'multiselect', options: ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'], init: [] },
	obligation: { type: 'select', options: ['obligate', 'free'] },
	obligation_display: { type: 'form' },
	motivation: { type: 'select', options: ['forWin', 'forJoy', 'both', 'others'] },
	motivation_display: { type: 'form' },
	eventFreq: { type: 'select', options: freqOptions },
	event_display: { type: 'form' },
	drinkingFreq: { type: 'select', options: freqOptions },
	drinking_display: { type: 'form' },
	tripFreq: { type: 'select', options: freqOptions },
	trip_display: { type: 'form' },
	publicEmail: { type: 'form' },
	publicEmailDescription: { type: 'form' },
	publicEmail2: { type: 'form' },
	publicEmail2Description: { type: 'form' },
	publicPhoneNumber: { type: 'form' },
	publicPhoneNumberDescription: { type: 'form' },
	twitterUrl: { type: 'form' },
	twitterUrlDescription: { type: 'form' },
	twitterUrl2: { type: 'form' },
	twitterUrl2Description: { type: 'form' },
	facebookUrl: { type: 'form' },
	facebookUrlDescription: { type: 'form' },
	lineId: { type: 'form' },
	lineIdDescription: { type: 'form' },
	lineId2: { type: 'form' },
	lineId2Description: { type: 'form' },
}

const sendClub = (_data: { [key: string]: any }) => {
	const { accountType, isValid, isRegisterCompleted, organizer, ...profile } =
		Object.fromEntries(Object.entries(_data).map(([key, value]) => {
			if (key === 'genre') return [key, (value as String).trim().split(' ')];
			if (data[key].type === 'int') return [key, parseInt(value)];
			if (data[key].type === 'ratio') return [key, Math.floor(parseFloat(value) * 10.0) / 10.0];
			if (data[key].type === 'bool') return [key, value === "true"];
			return [key, value]
		}))

	db.collection('clubs').add(
		{
			accountType,
			isValid,
			isRegisterCompleted,
			favoriteCount: 0,
			profile,
		}
	);
}

const randomGenClub : (() => { [key: string]: (string | boolean | number | string[]) }) = () => ({
	name: getRandomClubName(),
	nickname: getRandomNickName(),
	genre: getRandomSportsName(),
	imageUrl: getRandomImage(),
	iconImageUrl: getRandomIcon(),
	clubType: getRand(['sportsUnion', 'sports', 'culture', 'music', 'study', 'business', 'job', 'others']),
	isOfficial: getRand(["true", "false"]),
	isIntercollege: getRand(["true", "false"]),
	isOnlyKU: getRand(["true", "false"]),
	isCompany: getRand(["true", "false"]),
	hasSchoolRestrict: getRand(["true", "false"]),
	competitionFreq: getRand(freqOptions),
	competition_display: '大会や発表会はありません',
	description: `みんなで楽しく活動しています。練習にはOB・OGさんがいらっしゃってくださり、指導いただいています。\nイベントや行事などの練習以外の活動も積極的に行っており、メンバーの中がとても良いです。\n回生問わずメンバーを募集しているので、ぜひ見学会に来てください！`,
	memberCount: getRandInt(3, 100),
	genderRatio: getRandFloat(),
	kuRatio: getRandFloat(),
	place_display: '主に農学部グラウンドで活動しています。状況によっては市民グラウンドを利用することもあります',
	campus: getRand(['yoshidaMain', 'yoshidaNorth', 'yoshidaSouth', 'yoshidaWest', 'yoshidaOthers', 'uji', 'katsura', 'others']),
	freq: getRand(freqOptions),
	freq_display: '毎週月曜と水曜に活動しています。金曜には自主練をしています。',
	daysOfWeek: getRandMul(['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']),
	obligation: getRand(['obligate', 'free']),
	obligation_display: '基本的に自由参加ですが、大部分のメンバーが練習に参加しています',
	motivation: getRand(['forWin', 'forJoy', 'both', 'others']),
	motivation_display: '一部のメンバーは大会での入賞を目指していますが、半数以上はエンジョイ勢です',
	eventFreq: getRand(freqOptions),
	event_display: '合宿に加えて遠足や日帰り旅行を企画しています。',
	drinkingFreq: getRand(freqOptions),
	drinking_display: 'イベント後、参加したいメンバーで飲み会をする場合が多いです。10人程度参加します',
	tripFreq: getRand(freqOptions),
	trip_display: '毎年春に企画しています。昨年は滋賀へ行きました',
	publicEmail: getRandomNickName().toLowerCase() + '@example.com',
	publicEmailDescription: '新歓用アドレス（新歓期）',
	publicEmail2: getRandomNickName().toLowerCase() + '@example.com',
	publicEmail2Description: 'サークル共用アドレス（新歓期以外）',
	publicPhoneNumber: `031234${Math.floor(Math.random()*1000).toString().padStart(4, '0')}`,
	publicPhoneNumberDescription: '部長',
	twitterUrl: 'https://twitter.com/Twitter',
	twitterUrlDescription: 'サークルTwitter',
	lineId: '12345678',
	lineIdDescription: '新歓担当者LINE',
})

export { data as clubModel, sendClub, randomGenClub };