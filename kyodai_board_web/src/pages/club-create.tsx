import { useState } from 'react'
import { Header, Form, Checkbox, Button } from 'semantic-ui-react'
import ClubPrivate, { clubForm, clubFormRandom } from '../lib/models/club/clubPrivate'
import Club, { clubProfileForm, profileFormRandom } from '../lib/models/club/club'
import getValues from '../lib/models/utils/enumValues'
import css from "./club-create.module.scss"
import keyToLabel from '../lib/models/utils/keyToLabel'
import useAuthAPI from '../lib/auth/useAuthAPI'

const REQUIRED_PREFIX = " *"

export default function ClubCreate() {
	const [club, setClub] = useState<Omit<ClubPrivate, 'profile'> & Club>(() =>
			Object.fromEntries(
				[
					...Object.entries(clubForm)
							.map(([name, [_, __, ___, init]]: [keyof (ClubPrivate & Club), [string, string, boolean, any ?]]) => [name, init]),
					...Object.entries(clubProfileForm)
						.map(([name, [_, __, ___, init]]: [keyof (ClubPrivate & Club), [string, string, boolean, any?]]) => [name, init])
				]
			))

	const { axios } = useAuthAPI()
	const handleSend = async () => {
		const { accountType, ...rest } = club
		await axios.post('/api/postClub', {
			...rest,
			clubPrivate: { accountType }
		} as Club)
	}

	const handleSetRandom = () => {
		setClub({ ...club, ...clubFormRandom(), ...profileFormRandom() })
	}

	return (
		<div className={css.formBase}>
			<Header as='h1'>新規団体追加</Header>
			<Form className={css.formWrapper}>
				<Form.Group>
					<Button primary onClick={handleSend}>送信</Button>
					<Button color="olive" onClick={handleSetRandom}>ランダム</Button>
				</Form.Group>
				{
					Object.entries({...clubForm, ...clubProfileForm}).map(([name, [ type, label, required ]]: [keyof (Omit<ClubPrivate, 'profile'> & Club), [string, string, boolean, any?]]) => {
						if(type === "string"){
							return (
								<Form.Field key={name}>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<input placeholder={name} required value={club[name]?.toString() ?? ""} onChange={e => setClub({ ...club, [name]: e.target.value })} />
								</Form.Field>
							)
						}else if (type === "number") {
							return (
								<Form.Field key={name}>
									<label>{label}</label>
									<input type="number" placeholder={name} value={club[name]?.toString() ?? ""} onChange={e => setClub({ ...club, [name]: e.target.value })} />
								</Form.Field>
							)
						}else if(type === "boolean"){
							return (
								<Form.Group key={name} grouped>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<div className={css.optionWrap}>
										<Form.Radio
											className={css.field}
											label='はい'
											value='true'
											checked={club[name] as boolean}
											onChange={() => setClub(prev => ({...prev, [name]: true, }))}
										/>
										<Form.Radio
											className={css.field}
											label='いいえ'
											value='false'
											checked={!(club[name] as boolean)}
											onChange={() => setClub(prev => ({ ...prev, [name]: false, }))}
										/>
									</div>
								</Form.Group>
							)
						}else if(type === "genre"){
							return (
								<Form.Group key={name}>
									<Form.Field width="5">
										<label>{label + '1' + (required ? REQUIRED_PREFIX : "")}</label>
										<input placeholder={name} required value={(club[name] as string[])[0] ?? ""}
											onChange={e => {
												const prev = [...(club[name] as [string?, string?, string?])]
												prev[0] = e.target.value
												return setClub({ ...club, [name]: prev })
											}}
										/>
									</Form.Field>
									<Form.Field width="5">
										<label>{label + '2' + (required ? REQUIRED_PREFIX : "")}</label>
										<input placeholder={name} required value={(club[name] as string[])[1] ?? ""}
											onChange={e => {
												const prev = [...(club[name] as [string?, string?, string?])]
												prev[1] = e.target.value
												return setClub({ ...club, [name]: prev })
											}}
										/>
									</Form.Field>
									<Form.Field width="5">
										<label>{label + '3' + (required ? REQUIRED_PREFIX : "")}</label>
										<input placeholder={name} required value={(club[name] as string[])[2] ?? ""}
											onChange={e => {
												const prev = [...(club[name] as [string?, string?, string?])]
												prev[2] = e.target.value
												return setClub({ ...club, [name]: prev })
											}}
										/>
									</Form.Field>
								</Form.Group>
							)
						}else if(type === "DayOfWeek[]" || type === "Campus[]" || type === "UnivGrade[]"){
							const options = getValues(type.slice(0, -2))
							return (
								<Form.Group key={name} grouped>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<div className={css.optionWrap}>
										{options.map(option => {
											const isChecked = (club[name] as unknown as string[])?.includes(option) ?? false
											return (
												<Form.Checkbox
													key={option}
													className={css.field}
													label={keyToLabel(option)}
													value={option}
													checked={isChecked ?? false}
													onChange={() => setClub(prev => {
														if (isChecked) {
															return { ...prev, [name]: (Array.isArray(prev[name]) ? prev[name] as unknown as string[] : [])?.filter(item => item !== option) }
														} else {
															return { ...prev, [name]: [...(Array.isArray(prev[name]) ? prev[name] as unknown as string[] : []), option] }
														}
													})} />
											)
										})}
									</div>
								</Form.Group>
							)
						}else{
							const options = getValues(type)
							return (
								<Form.Group key={name} grouped>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<div className={css.optionWrap}>
										{options.map(option => (
											<Form.Radio
												key={option}
												className={css.field}
												label={keyToLabel(option)}
												value={option}
												checked={club[name] === option}
												onChange={() => setClub(prev => ({ ...prev, [name]: option, }))}
											/>
										))}
									</div>
								</Form.Group>
							)
						}
					})
				}
				<Button primary fluid onClick={handleSend}>送信</Button>
			</Form>
		</div>
	)
}
