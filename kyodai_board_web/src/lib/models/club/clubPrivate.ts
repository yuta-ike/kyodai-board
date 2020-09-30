import getRandom from "../../../utils/getRandom";
import { getAccoutTypes } from "../utils/enumValues";
import Club from "./club";

export type AccountType = "normal" | "temporary"

export default class ClubPrivate{
	constructor(
		readonly accountType: AccountType,
	){}
}

export const clubForm: {[P in keyof ClubPrivate]: [string, string, boolean, ClubPrivate[P]?]} = {
	accountType: ['AccountType', "アカウント種別", true, "normal"],
}

export const clubFormRandom: () => { [P in keyof ClubPrivate]: ClubPrivate[P]} = () => ({
	accountType: getRandom(getAccoutTypes()),
})