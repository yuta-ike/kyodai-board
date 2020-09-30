import { useEffect, useState } from 'react'
import { Container } from 'next/app'
import { Header, Form, Checkbox, Button, Select, Divider, Dropdown } from 'semantic-ui-react'
import getValues from '../lib/models/utils/enumValues'
import css from "./event-create.module.scss"
import keyToLabel from '../lib/models/utils/keyToLabel'
import useAuthAPI from '../lib/auth/useAuthAPI'
import { eventForm, eventFormRandom } from '../lib/models/event/event'
import useSWR from 'swr'
import Club from '../lib/models/club/club'

const REQUIRED_PREFIX = " *"

export default function EventCreate() {
	const { axios, key } = useAuthAPI()
	const { data: clubs } = useSWR(key("clubs"), () => axios.get<(Club & {id: string})[]>("/api/getClubs"))

	const [clubId, setClubId] = useState<string>()
	const [event, setClub] = useState<Event>(() =>
			Object.fromEntries(
				[
					...Object.entries(eventForm)
							.map(([name, [_, __, ___, init]]: [keyof Event, [string, string, boolean, any ?]]) => [name, init]),
				]
			))

	const handleSend = async () => {
		await axios.post(`/api/${clubId}/postEvent`, event)
	}

	const handleSetRandom = () => {
		setClub({ ...event, ...eventFormRandom() })
	}

	return (
		<div className={css.formBase}>
			<Header as='h1'>新規イベント追加</Header>
			<Form className={css.formWrapper}>
				<Form.Group>
					<Button primary onClick={handleSend}>送信</Button>
					<Button color="olive" onClick={handleSetRandom}>ランダム</Button>
				</Form.Group>
				<Form.Group grouped>
					<label>団体名</label>
					<Dropdown
						control='select'
						value={clubId}
						onChange={(_, { value }) => setClubId(value as string)}
						options={clubs?.data.map(club => ({ key: club.id, text: club.name, value: club.id })) ?? []}
						placeholder="団体名を選択"
						selection
						fluid
					/>
				</Form.Group>
				<Divider/>
				{
					Object.entries(eventForm).map(([name, [ type, label, required ]]: [keyof Event, [string, string, boolean, any?]]) => {
						if(type === "string"){
							return (
								<Form.Field key={name}>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<input placeholder={name} required value={event[name]?.toString() ?? ""} onChange={e => setClub({ ...event, [name]: e.target.value })} />
								</Form.Field>
							)
						}else if (type === "number") {
							return (
								<Form.Field key={name}>
									<label>{label}</label>
									<input type="number" placeholder={name} value={event[name]?.toString() ?? ""} onChange={e => setClub({ ...event, [name]: e.target.value })} />
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
											checked={event[name] as boolean}
											onChange={() => setClub(prev => ({...prev, [name]: true, }))}
										/>
										<Form.Radio
											className={css.field}
											label='いいえ'
											value='false'
											checked={!(event[name] as boolean)}
											onChange={() => setClub(prev => ({ ...prev, [name]: false, }))}
										/>
									</div>
								</Form.Group>
							)
						}else if(type === "DayOfWeek[]" || type === "Campus[]" || type === "UnivGrade[]"){
							const options = getValues(type.slice(0, -2))
							return (
								<Form.Group key={name} grouped>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<div className={css.optionWrap}>
										{options.map(option => {
											const isChecked = (event[name] as unknown as string[])?.includes(option) ?? false
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
												checked={event[name] === option}
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
