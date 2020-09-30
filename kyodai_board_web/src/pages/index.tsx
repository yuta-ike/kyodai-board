import Head from 'next/head'
import useSWR from 'swr'
import Link from 'next/link'
import { useUser } from '../lib/auth/useUser'

const fetcher = (url: string, token: string) =>
  fetch(url, {
    method: 'GET',
    headers: new Headers({ 'Content-Type': 'application/json', token }),
    credentials: 'same-origin',
  }).then((res) => res.json())

const Index = () => {
  const { user, logout } = useUser()
  const { data, error } = useSWR(
    user ? ['/api/getFood', user.token] : null,
    fetcher
  )

  if (!user) {
    return (
      <>
        <Head>
          <title>First Post</title>
        </Head>
        <p>Here is INDEX</p>
        <p>
          You are not signed in.{' '}
          <Link href={'/auth'}>
            <a>Sign in</a>
          </Link>
        </p>
      </>
    )
  }

  return (
    <>
      <Head>
        <title>First Post</title>
      </Head>
      <div>
        <div>
          <p>You're signed in. Email: {user.email}</p>
          <p
            style={{
              display: 'inline-block',
              color: 'blue',
              textDecoration: 'underline',
              cursor: 'pointer',
            }}
            onClick={() => logout()}
          >
            Log out
          </p>
        </div>
        <div>
          <Link href={'/example'}>
            <a>Another example page</a>
          </Link>
        </div>
        {error && <div>Failed to fetch food!</div>}
        {data && !error ? (
          <div>Your favorite food is {data.food}.</div>
        ) : (
          <div>Loading...</div>
        )}
      </div>
    </>
  )
}

export default Index
