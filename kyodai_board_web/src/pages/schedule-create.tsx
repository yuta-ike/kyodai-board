import { useState } from 'react'
import { Header, Form, Button, Divider, Dropdown } from 'semantic-ui-react'
import getValues from '../lib/models/utils/enumValues'
import css from "./event-create.module.scss"
import keyToLabel from '../lib/models/utils/keyToLabel'
import useAuthAPI from '../lib/auth/useAuthAPI'
import useSWR from 'swr'
import Event from '../lib/models/event/event'
import Schedule, { scheduleForm, scheduleFormRandom } from '../lib/models/schedule/schedule'
import { DateTimeInput } from 'semantic-ui-calendar-react';
import Club from '../lib/models/club/club'

const REQUIRED_PREFIX = " *"

export default function EventCreate() {
	const { axios, key } = useAuthAPI()
	const [eventId, setEventId] = useState<string>()
	const [clubId, setClubId] = useState<string>()
	
	const { data: clubs } = useSWR(key("clubs"), () => axios.get<(Club & { id: string })[]>("/api/getClubs"))
	const { data: events } = useSWR(clubId == null ? null : key("events" + clubId), () => axios.get<(Event & { id: string })[]>(`/api/${clubId}/getEvents`))
	const [schedule, setSchedule] = useState<Schedule>(() =>
			Object.fromEntries(
				[
					...Object.entries(scheduleForm)
						.map(([name, [_, __, ___, init]]: [keyof Schedule, [string, string, boolean, any ?]]) => [name, init]),
				]
			))

	const handleSend = async () => {
		await axios.post(`/api/${clubId}/${eventId}/postSchedule`, schedule)
	}

	const handleSetRandom = () => {
		setSchedule({ ...schedule, ...scheduleFormRandom() })
	}

	return (
		<div className={css.formBase}>
			<Header as='h1'>新規スケジュール追加</Header>
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
				<Form.Group grouped>
					<label>イベント名</label>
					<Dropdown
						control='select'
						value={eventId}
						onChange={(_, { value }) => setEventId(value as string)}
						options={events?.data.map(event => ({ key: event.id, text: event.title, value: event.id })) ?? []}
						placeholder="団体名を選択"
						selection
						fluid
					/>
				</Form.Group>
				<Divider/>
				{
					Object.entries(scheduleForm).map(([name, [ type, label, required ]]: [keyof Schedule, [string, string, boolean, any?]]) => {
						if(type === "string"){
							return (
								<Form.Field key={name}>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<input placeholder={name} required value={schedule[name]?.toString() ?? ""} onChange={e => setSchedule({ ...schedule, [name]: e.target.value })} />
								</Form.Field>
							)
						}else if (type === "number") {
							return (
								<Form.Field key={name}>
									<label>{label}</label>
									<input type="number" placeholder={name} value={schedule[name]?.toString() ?? ""} onChange={e => setSchedule({ ...schedule, [name]: e.target.value })} />
								</Form.Field>
							)
						}else if(type === "Date"){
							return (
								<Form.Group key={name} grouped>
									<label>{label}</label>
									<DateTimeInput
										dateTimeFormat="YYYY-MM-DDTHH:mm:ss.000Z"
										value={schedule[name]}
										onChange={(_, data) => {
											setSchedule(prev => ({...prev, [name]: data.value}))
										}}
									/>
								</Form.Group>
							)
						}if(type === "DayOfWeek[]" || type === "Campus[]" || type === "UnivGrade[]"){
							const options = getValues(type.slice(0, -2))
							return (
								<Form.Group key={name} grouped>
									<label>{label + (required ? REQUIRED_PREFIX : "")}</label>
									<div className={css.optionWrap}>
										{options.map(option => {
											const isChecked = (schedule[name] as unknown as string[])?.includes(option) ?? false
											return (
												<Form.Checkbox
													key={option}
													className={css.field}
													label={keyToLabel(option)}
													value={option}
													checked={isChecked ?? false}
													onChange={() => setSchedule(prev => {
														if (isChecked) {
															return { ...prev, [name]: (Array.isArray(prev[name]) ? prev[name] as unknown as string[] : [])?.filter(item => item !== option) }
														} else {
															return { ...prev, [name]: [...(Array.isArray(prev[name]) ? prev[name] as unknown as string[] : []), option] }
														}
													})}
												/>
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
												checked={schedule[name] === option}
												onChange={() => setSchedule(prev => ({ ...prev, [name]: option, }))}
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
