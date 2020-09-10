import React from 'react'
import { TextInput, Button, RadioButtonGroup, CheckBoxGroup } from 'grommet';
import useForm from '../utils/useForm';

export type formDataType =
		{ type: 'form' | 'int' | 'ratio', init?: string, onUpdate?: (value: string | number, updateValue: (key: string, value: string | number | boolean | Date | string[]) => void) => void }
	| { type: 'multiselect', options: string[], init?: string[], onUpdate?: (value: string[], updateValue: (key: string, value: string | number | boolean | Date | string[]) => void) => void }
	| { type: 'select', options: string[], init?: string, onUpdate?: (value: string, updateValue: (key: string, value: string | number | boolean | Date | string[]) => void) => void }
	| { type: 'bool', init?: boolean, onUpdate?: (value: string, updateValue: (key: string, value: string | number | boolean | Date | string[]) => void) => void }
	| { type: 'date', init?: string, onUpdate?: (value: string, updateValue: (key: string, value: string | number | boolean | Date | string[]) => void) => void }

type FormProps = {
	data: { [key: string]: formDataType },
	onClickSend: (data: { [key: string]: any }) => void,
	randomGen: () => { [key: string]: (string | boolean | number | string[] | Date) },
}

const Form: React.FC<FormProps> = ({ data, onClickSend, randomGen }) => {
	const [values, handleValues, updateValue, updateValuesAll] = useForm(
		Object.fromEntries(Object.entries(data).map(([key, value]) => [ key, value?.init ?? '']))
	);
	return (
		<div className="page form">
			<Button primary label="ランダム" onClick={() => updateValuesAll(randomGen())} />
			{
				Object.entries(data).map(([key, formData]) => {
					if (formData.type === 'form'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<TextInput
									id={key}
									name={key}
									value={values[key] as string}
									onChange={e => {
										handleValues(key)(e);
										formData.onUpdate?.(e.target.value, updateValue)
									}}
								/>
							</div>
						);
					}else if(formData.type === 'select'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<RadioButtonGroup
									id={key}
									name={key}
									direction='row'
									options={formData.options}
									value={values[key]}
									onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
										console.log(key, e.target.value)
										formData.onUpdate?.(e.target.value, updateValue)
										updateValue(key, e.target.value);
									}}
									wrap={true}
								/>
							</div>
						);
					}else if(formData.type === 'bool'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<RadioButtonGroup
									id={key}
									name={key}
									direction='row'
									options={["true", "false"]}
									value={values[key]}
									onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
										handleValues(key)(e);
										formData.onUpdate?.(e.target.value, updateValue)
									}}
									wrap={true}
								/>
							</div>
						);
					}else if(formData.type === 'multiselect'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<CheckBoxGroup
									id={key}
									name={key}
									direction='row'
									options={
										formData.options.map((str) => ({
											name: str,
											label: str,
										}))
									}
									valueKey={"label"}
									value={values[key] as string[]}
									onChange={(e: any) => {
										if(e.target.checked){
											const newValue = [...(values[key] as string[]), e.target.name];
											updateValue(key, newValue)
											formData.onUpdate?.(newValue, updateValue)
										}else{
											const newValue = (values[key] as string[]).filter(elm => elm !== e.target.name);
											updateValue(key, newValue);
											formData.onUpdate?.(newValue, updateValue)
										}
									}}
									wrap={true}
								/>
							</div>
						);
					}else if(formData.type === 'int'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<TextInput
									id={key}
									name={key}
									value={values[key] as number}
									onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
										handleValues(key)(e);
										formData.onUpdate?.(e.target.value, updateValue)
									}}
								/>
							</div>
						);
					}else if(formData.type === 'ratio'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<TextInput
									id={key}
									name={key}
									value={values[key] as number}
									onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
										handleValues(key)(e);
										formData.onUpdate?.(e.target.value, updateValue)
									}}
								/>
							</div>
						);
					}
					else if (formData.type === 'date'){
						return (
							<div key={key}>
								<label htmlFor={key}>{key}</label>
								<TextInput
									id={key}
									name={key}
									value={values[key] as string}
									onChange={(e: React.ChangeEvent<HTMLInputElement>) => {
										handleValues(key)(e);
										formData.onUpdate?.(e.target.value, updateValue)
									}}
								/>
							</div>
						)
					}
				})
			}
			<Button primary label="確定" onClick={() => onClickSend(values)}/>
		</div>
	)
}
export default Form;
