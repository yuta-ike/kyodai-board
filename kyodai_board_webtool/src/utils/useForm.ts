import { useState } from 'react'

const useForm = (init: { [key: string]: (string | boolean | number | string[] | Date) })
	: [{ [key: string]: (string | boolean | number | string[] | Date) },
			(key: string) => (e: React.ChangeEvent<HTMLInputElement>) => void,
			(key: string, value: (string | boolean | number | string[] | Date)) => void,
			(_values: { [key: string]: string | number | boolean | string[] | Date; }) => void
		] => {
	const [values, setValues] = useState(init);
	const updateValues = (key: string, value: any) => {
		setValues(prev => ({ ...prev, [key]: value }));
	}
	const handleValues = (key: string) => (e: React.ChangeEvent<HTMLInputElement>) => {
		updateValues(key, e.target.value);
	}
	const updateValuesAll = (_values: { [key: string]: (string | boolean | number | string[] | Date) }) => {
		setValues({...values, ..._values});
	}
	return [values, handleValues, updateValues, updateValuesAll];
}

export default useForm;