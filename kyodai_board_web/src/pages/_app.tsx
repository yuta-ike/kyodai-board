import { AppProps } from 'next/app'
import Link from 'next/link'
import 'semantic-ui-css/semantic.min.css'
import { Sticky, Menu, Tab } from 'semantic-ui-react'

const _app: React.FC<AppProps> = ({ Component, pageProps }) => {
	return (
		<>
			<Sticky>
				<Menu
					attached='top'
					tabular
					style={{ backgroundColor: '#fff', paddingTop: '1em' }}
				>
					<Link href="/club-create">
						<Menu.Item as='a' active={false} name='団体'/>
					</Link>
					<Link href="/event-create">
						<Menu.Item as='a' active={false} name='イベント'/>
					</Link>
					<Link href="/schedule-create">
						<Menu.Item as='a' active={false} name='スケジュール'/>
					</Link>
				</Menu>
			</Sticky>
			<Component {...pageProps}/>
		</>
	)
}

export default _app
