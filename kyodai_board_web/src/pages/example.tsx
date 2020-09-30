import Link from 'next/link'
import Screen from '../components/Screen'
import useAuthAPI from '../lib/auth/useAuthAPI'

const Example: React.FC = () => {
  const axios = useAuthAPI()
  const handleClick = async () => {
    await axios.post('/api/postClub', {
      name: "APPLE",
    })
  }

  return (
    <Screen>
      <p>
        This page is static because it does not fetch any data or include the
        authed user info.
      </p>
      <Link href={'/'}>
        <a>Home</a>
      </Link>
      <button onClick={handleClick}>SEND</button>
    </Screen>
  )
}

export default Example


