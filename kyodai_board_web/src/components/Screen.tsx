import Head from 'next/head'

const Screen: React.FC = ({ children }) => {
	return (
		<>
			<Head>
				<title>京大ボード ウェブ</title>
			</Head>
			{ children }
		</>
	)
}

export default Screen;