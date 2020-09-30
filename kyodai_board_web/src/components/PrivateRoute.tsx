import { GetServerSideProps } from 'next'
import { useEffect } from 'react'
import { useRouter } from 'next/router'
import { verifyIdToken } from '../lib/auth/firebaseAdmin'

export type AuthProps = {
	isAuthenticated: boolean,
}

const Screen: React.FC<AuthProps> = ({ children, isAuthenticated }) => {
	const router = useRouter();
	useEffect(() => {
		if(!isAuthenticated){
			router.push('/auth')
		}
	}, [isAuthenticated])

	return <> { children } </>
}

export default Screen;

export const getServerSideProps: GetServerSideProps = async (context) => {
	const token = context.req.headers.token as any

	try {
		const res = await verifyIdToken(token)
		return {
			props: { isAuthenticated: res != null },
		}
	} catch (error) {
		return {
			props: { isAuthenticated: false },
		}
	}
}