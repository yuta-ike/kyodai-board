import { AccountType } from "../club/clubPrivate"
import { Campus, ClubType, DayOfWeek, Freq, SubClubType, UnivGrade } from "../club/club"
import { ApplyMethod, WeatherCancel } from "../event/event"

const getValues = (enumType: string) => {
	if (enumType == "AccountType"){
		return ["normal", "temporary"]
	}else if(enumType == "ClubType"){
		return ['sportsUnion', 'sports', 'culture', 'music', 'tech', 'study', 'business', 'job', 'others']
	}else if (enumType == "SubClubType") {
		return ['sportsUnion', 'sports', 'culture', 'music', 'tech', 'study', 'business', 'job', 'none']
	}else if(enumType === "Freq"){
		return ['almostEveryday', 'fiveTimesPerWeek', 'fourTimesPerWeek', 'threeTimesPerWeek', 'twicePerWeek', 'oncePerWeek', 'twicePerMonth', 'oncePerMonth', 'oncePerTwoMonth', 'oncePerThreeMonth', 'threeTimesPerYear', 'oncePerHalfYear', 'oncePerYear', 'moreRare', 'none', 'others']
	}else if(enumType === "Campus"){
		return ['yoshida', 'uji', 'katsura', 'others']
	}else if(enumType === "DayOfWeek"){
		return ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'irregular']
	}else if (enumType === "WeatherCancel"){
		return ['cancelWhenRain', 'cancelWhenHardRain', 'noCancel', 'others']
	}else if (enumType === "UnivGrade"){
		return ['first', 'second', 'third', 'fourth', 'postFirst', 'postSecond', 'preFirst', 'older']
	}else if (enumType === "ApplyMethod"){
		return ['appform', 'appchat', 'webpage', 'googleform', 'twitter', 'line', 'facebook', 'email', 'others', 'noneed']
	}

	throw new Error(`Unimplemented Error. enumType = ${enumType}`)
}

export const getAccoutTypes = (): AccountType[] => ["normal", "temporary"]
export const getClubTypes = (): ClubType[] => ['sportsUnion', 'sports', 'culture', 'music', 'tech', 'study', 'business', 'job', 'others']
export const getSubClubTypes = (): SubClubType[] => ['sportsUnion', 'sports', 'culture', 'music', 'tech', 'study', 'business', 'job', 'none']
export const getFreqs = (): Freq[] => ['almostEveryday', 'fiveTimesPerWeek', 'fourTimesPerWeek', 'threeTimesPerWeek', 'twicePerWeek', 'oncePerWeek', 'twicePerMonth', 'oncePerMonth', 'oncePerTwoMonth', 'oncePerThreeMonth', 'threeTimesPerYear', 'oncePerHalfYear', 'oncePerYear', 'moreRare', 'none', 'others']
export const getCampuses = (): Campus[] => ['yoshida', 'uji', 'katsura', 'others']
export const getDaysOfWeek = (): DayOfWeek[] => ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'irregular']
export const getWeatherCancels = (): WeatherCancel[] => ['cancelWhenRain', 'cancelWhenHardRain', 'noCancel', 'others']
export const getUnivGrades = (): UnivGrade[] => ['first', 'second', 'third', 'fourth', 'postFirst', 'postSecond', 'preFirst', 'older']
export const getApplyMethods = (): ApplyMethod[] => ['appform', 'appchat', 'webpage', 'googleform', 'twitter', 'line', 'facebook', 'email', 'others', 'noneed']

export default getValues