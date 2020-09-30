import FirebaseAuth from '../components/FirebaseAuth'
import { useUser } from '../lib/auth/useUser'
import * as styles from './auth.module.scss'

const Auth = () => {
	useUser()
	return (
		<div className={styles.buttonWrapper}>
			<FirebaseAuth />
		</div>
	)
}

export default Auth
