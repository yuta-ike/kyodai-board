const sports =
["アーマードバトル", "アイスホッケー", "アグレッシブインラインスケート", "アクロバット", "アメリカンフットボール", "アンプティサッカー", "eスポーツ", "一輪車", "インラインアルペン", "ウインドサーフィン", "ARスポーツ", "エクストリームスポーツ", "オーストラリアンフットボール", "カヌースラローム", "空手", "キックボクシング", "競技ダンス", "クリケット", "車いすバスケットボール", "車いすマラソン", "コーフボール", "ゴルフ", "サッカー", "自転車競技", "柔道", "シュートボクシング", "シンクロナイズドスイミング", "水泳", "スカッシュ", "スケートボード", "ストリートスポーツ", "スノーボード", "スポーツフィッシング", "スラックライン", "セーリング", "セパタクロー", "ダーツ", "体操", "ダブルダッチ", "チアダンス", "ディスクゴルフ", "テコンドー", "デスマッチ", "テニス", "ドッジボール", "トライアスロン", "トレイルランニング", "バイクトライアル", "バスケットボール", "バドミントン", "パラスポーツ", "パルクール", "バレエ", "パワーリフティング", "ハンググライダー", "ハンドボール", "BMX", "ビーチサッカー", "ビーチテニス", "ビーチバレーボール", "ビーチフラッグス", "ビリヤード", "フットゴルフ", "フットサル", "フットバッグ", "フリースタイルフットボール", "ブレイクダンス", "フレスコボール", "フロアボール", "プロレス", "ボウリング", "ボクシング", "ボブスレー", "モータースポーツ", "野球", "ライフセービング", "ライフル射撃", "ラグビー", "ラクロス", "ラフティング", "ランニング", "レスリング"]

const colors =
["INDIANRED", "LIGHTCORAL", "SALMON", "DARKSALMON", "LIGHTSALMON", "CRIMSON", "RED", "FIREBRICK", "DARKRED", "PINK", "LIGHTPINK", "HOTPINK", "DEEPPINK", "MEDIUMVIOLETRED", "PALEVIOLETRED", "LIGHTSALMON", "CORAL", "TOMATO", "ORANGERED", "DARKORANGE", "ORANGE", "GOLD", "YELLOW", "LIGHTYELLOW", "LEMONCHIFFON", "PAPAYAWHIP", "MOCCASIN", "PEACHPUFF", "PALEGOLDENROD", "KHAKI", "DARKKHAKI", "LAVENDER", "THISTLE", "PLUM", "VIOLET", "ORCHID", "FUCHSIA", "MAGENTA", "MEDIUMORCHID", "MEDIUMPURPLE", "REBECCAPURPLE", "BLUEVIOLET", "DARKVIOLET", "DARKORCHID", "DARKMAGENTA", "PURPLE", "INDIGO", "SLATEBLUE", "DARKSLATEBLUE", "MEDIUMSLATEBLUE", "GREENYELLOW", "CHARTREUSE", "LAWNGREEN", "LIME", "LIMEGREEN", "PALEGREEN", "LIGHTGREEN", "MEDIUMSPRINGGREEN", "SPRINGGREEN", "MEDIUMSEAGREEN", "SEAGREEN", "FORESTGREEN", "GREEN", "DARKGREEN", "YELLOWGREEN", "OLIVEDRAB", "OLIVE", "DARKOLIVEGREEN", "MEDIUMAQUAMARINE", "DARKSEAGREEN", "LIGHTSEAGREEN", "DARKCYAN", "TEAL"]
const images = [
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/sample.jpg?alt=media&token=296e663c-19c8-4123-bdd0-2941f7648dc7',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/IMG_6612.jpg?alt=media&token=470c640b-bdde-4f73-b68f-f1ef432641d7',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/IMG_6371.jpg?alt=media&token=1c00476b-eb73-409f-ab96-18dd31a6ea04',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/IMG_6224.jpg?alt=media&token=7be877e9-610d-4144-9038-07a414cfce39',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/IMG_6086.jpg?alt=media&token=d24285b7-b87b-414f-9962-52d1fea44bee',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/teruterubouzu.jpg?alt=media&token=c27a6967-1a4c-48ce-98e4-2d16e49be5d3',
	'https://firebasestorage.googleapis.com/v0/b/kyodai-board.appspot.com/o/IMG_6401.jpg?alt=media&token=dcf13577-42dc-40db-9b2c-ccc41e159174',
]
const avaters = [
	'https://3.bp.blogspot.com/-2VIWJTc7MBs/VCIiteBs3wI/AAAAAAAAmec/BkjJno4Qh5U/s800/animal_buta.png',
	'https://4.bp.blogspot.com/-7DLdBODmEqc/VCIitQRzAWI/AAAAAAAAmeY/g1fjm8NqyaI/s800/animal_arupaka.png',
	'https://3.bp.blogspot.com/-n0PpkJL1BxE/VCIitXhWwpI/AAAAAAAAmfE/xLraJLXXrgk/s800/animal_hamster.png',
	'https://1.bp.blogspot.com/-4N2T5W6jo_o/VCIiuUHNwEI/AAAAAAAAmeo/_lyIGo3afK4/s800/animal_hiyoko.png',
	'https://1.bp.blogspot.com/-FfjY4DibSI4/VCIiuxKtLRI/AAAAAAAAmes/40lCg_r9U2g/s800/animal_inu.png',
	'https://2.bp.blogspot.com/-dvDN3SxnRWE/VCIivNhugVI/AAAAAAAAmew/sEC6XC1sGwk/s800/animal_kuma.png',
	'https://3.bp.blogspot.com/--IJXuiGRidY/WNir5IfLk3I/AAAAAAABC28/81L3mxcIe9EoqcK9uqCXbVxZ4YO36JzlQCLcB/s800/animal_mitsubachi.png',
	'https://1.bp.blogspot.com/-LFh4mfdjPSQ/VCIiwe10YhI/AAAAAAAAme0/J5m8xVexqqM/s800/animal_neko.png',
	'https://4.bp.blogspot.com/-xHGCCaOsEIU/VCIixHoXZTI/AAAAAAAAmfQ/Ek3BjRbafrQ/s800/animal_panda.png',
	'https://4.bp.blogspot.com/-CtY5GzX0imo/VCIixcXx6PI/AAAAAAAAmfY/AzH9OmbuHZQ/s800/animal_penguin.png',
]


type tyGetRandom = <T>(arr: T[]) => T
const getRandom: tyGetRandom = (arr) => arr[Math.floor(Math.random() * arr.length)]
const getRandomInt = (min: number, max: number) => Math.floor(Math.random() * (max - min)) + min
const getRandomName = () => {
	const rand = Math.random()
	const rand2 = Math.random();
	if (Math.random() < 0.5) {
		const prefix = rand < 0.3 ? '京都大学' : rand < 0.6 ? '京都' : '';
		const postfix = rand < 0.3 ? '部' : rand < 0.6 ? 'サークル' : '同好会';
		return `${prefix}${sports[Math.floor(Math.random() * sports.length)]}${postfix}`
	} else {
		const prefix = rand < 0.5 ? '京大' : '';
		const name = colors[Math.floor(Math.random() * colors.length)];
		return `${prefix}${rand2 < 0.5 ? name.toLowerCase() : name}`
	}
}

const getRandomShortName = () => {
	return colors[Math.floor(Math.random() * colors.length)].substring(0, Math.floor(Math.random() * 3 + 3))
}


const getRandomSportsName = () => {
	const count = Math.floor(Math.random() * 3) + 1;
	let res = '';
	for (let i = 0; i < count; i++) {
		res += `${sports[Math.floor(Math.random() * sports.length)]} `;
	}
	return res.trim();
}

const getRandomImage = () => {
	return images[Math.floor(Math.random() * images.length)]
}

const getRandomIcon = () => {
	return avaters[Math.floor(Math.random() * avaters.length)]
}

const getRandomMul = (arr: readonly any[]) => arr.filter(() => Math.random() > 0.7)

const getRandomAlphabet = () => getRandom(colors).toLowerCase()

export default getRandom
export { getRandomInt, getRandomName, getRandomShortName, getRandomSportsName, getRandomImage, getRandomIcon, getRandomMul, getRandomAlphabet }